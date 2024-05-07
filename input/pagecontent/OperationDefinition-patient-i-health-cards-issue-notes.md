A Health Wallet can `POST /Patient/:id/$health-cards-issue` to a FHIR-enabled issuer to request or generate a specific type of Health Card. The body of the POST looks like:

```json
{
  "resourceType": "Parameters",
  "parameter": [{
    "name": "credentialType",
    "valueUri": "Immunization"
  }]
}
```

The `credentialType` parameter is required. This parameter restricts the request
by high-level categories based on FHIR Resource Types such as "Observation" or
"Immunization". See [FHIR Resource Types](https://hl7.org/fhir/R4/resourcelist.html). 

Type-based filters evaluate Health Cards based on the FHIR resource types within the Health Card payload at `.vc.credentialSubject.fhirBundle.entry[].resource`.  Multiple `credentialType` parameters in one request SHALL be interpreted as a request for Health Cards that contain all of the requested types (logical AND). To maintain compatibility with the initial release of this specification, servers SHOULD process
`#immunization` as `Immunization`, and `#laboratory` as `Observation`.

The following parameters are optional; clients MAY include them in a request,
and servers MAY ignore them if present.

* **`credentialValueSet`**. Restricts the request by FHIR
content such as "any standardized vaccine code for mpox". See [Health Card ValueSets](https://terminology.smarthealth.cards/artifacts.html#terminology-value-sets).
Valueset-based filters apply to the FHIR Resources within the Health Card
payload at `.vc.credentialSubject.fhirBundle.entry[].resource`.  For
Immunizations, the `Immunization.vaccineCode` is evaluated. For Observations,
the `Observation.code` is evaluated. Multiple `credentialValueSet` parameters
in one request SHALL be interpreted as a request for credentials with content
from all of the supplied Valuesets (logical AND).

```json
{
  "resourceType": "Parameters",
  "parameter": [{
    "name": "credentialType",
    "valueUri": "Immunization"
  }, {
    "name": "credentialValueSet",
    "valueUri": "https://terminology.smarthealth.cards/ValueSet/immunization-orthopoxvirus-all"
  }]
}
```

* **`includeIdentityClaim`**. By default, the issuer will decide which identity claims to include, based on profile-driven guidance. If the Health Wallet wants to fine-tune identity claims in the generated credentials, it can provide an explicit list of one or more `includeIdentityClaim`s, which will limit the claims included in the VC. For example, to request that only name be included:

```json
{
  "resourceType": "Parameters",
  "parameter": [{
    "name": "credentialType",
    "valueUri": "Immunization"
  }, {
    "name": "includeIdentityClaim",
    "valueString": "Patient.name"
  }]
}
```

* **`_since`**. By default, the issuer will return Health Cards of any age. If the Health Wallet wants to request only cards pertaining to data since a specific point in time, it can provide a `_since` parameter with a `valueDateTime` (which is an ISO8601 string at the level of a year, month, day, or specific time of day using the extended time format; see [FHIR dateTime datatype](http://hl7.org/fhir/datatypes.html#dateTime) for details). For example, to request only COVID-19 data since March 2021:


```json
{
  "resourceType": "Parameters",
  "parameter": [{
    "name": "credentialType",
    "valueUri": "Immunization"
  }, {
    "name": "_since",
    "valueDateTime": "2021-03"
  }]
}
```

The **response** is a `Parameters` resource that includes one more more `verifiableCredential` values like:

```json
{
  "resourceType": "Parameters",
  "parameter":[{
    "name": "verifiableCredential",
    "valueString": "<<Health Card as JWS>>"
  }]
}
```

If no results are available, a `Parameters` resource without any `parameter` is returned:

```json
{
  "resourceType": "Parameters"
}
```

In the response, an optional repeating `resourceLink` parameter can capture the link between any number of hosted FHIR resources and their derived representations within the verifiable credential's `.credentialSubject.fhirBundle`, allowing the health wallet to explicitly understand these correspondences between `bundledResource` and `hostedResource`, without baking details about the hosted endpoint into the signed credential. The optional `vcIndex` value on a `resourceLink` can be used when a response contains more than one VC, to indicate which VC this resource link applies to. The `vcIndex` is a zero-based index of a `verifiableCredential` entry within the top-level `parameter` array.

```json
{
  "resourceType": "Parameters",
  "parameter": [{
    "name": "verifiableCredential",
    "valueString": "<<Health Card as JWS>>"
  }, {
    "name": "resourceLink",
    "part": [{
        "name": "vcIndex",
        "valueInteger": 0
      }, {
        "name": "bundledResource",
        "valueUri": "resource:2"
      }, {
        "name": "hostedResource",
        "valueUri": "https://fhir.example.org/Immunization/123"
    }]
  }]
}
```

<p></p>
<p></p>

