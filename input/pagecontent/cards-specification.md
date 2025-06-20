## Overview

### Health Cards Conceptual Model

<div>
<p></p>
<figure class="figure">
<figcaption class="figure-caption"><strong><i>Health Cards Conceptual Model</i></strong></figcaption>
  <br />
  <p>
  <img src="health-cards-conceptual.png" style="float:none; width:700px">  
  </p>
</figure>
</div>
<p></p>

_Adapted from Figure 1 of the [W3C Verifiable Credentials specification](https://www.w3.org/TR/vc-data-model)_

<p></p>

* **Issuer** (e.g., a lab, pharmacy, healthcare provider, EHR, public health department, or immunization information system) generates verifiable credentials
* **Holder** stores credentials and presents them at will
* **Verifier** receives credentials from holder and ensures they are properly signed

<p></p>

### Design Goals

* Support **end-to-end workflow** where users receive and present relevant healthcare data
* Enable workflow with **open standards**
* Support strong **cryptographic signatures**
* Enable **privacy preserving** data presentations for specific use cases

<p></p>

### Approach: Start Small -- Think Big

We enable Health Cards by defining building blocks that can be used across healthcare. The core building block allows us to aggregate data into meaningful sets, signed by an issuer, and stored/presented by a consumer as needed. The broader set of use cases should eventually include:

* Managing an immunization record that can be shared with schools or employers, or for travel
* Sharing verifiable health history data with clinical research studies
* Sharing voluntary data with public health agencies
* Sharing questionnaire responses with healthcare providers

When we launched the project, our short-term definition of success included:

* Represent "Health Cards" in a "Health Wallet", focusing on COVID-19 status
* Ensure that each role (issuer, holder, app) can be implemented by any organization following open standards, provided they sign on to the relevant [trust framework](glossary.html#trust-framework)

<p></p>

### User Experience and Data Flow

* **User Receives** a Health Card from an Issuer. The Health Card is a signed data artifact that the user can obtain through any of these methods:
    * issuer offers a Health Card on paper or PDF, including a QR code (required method)
    * issuer offers a Health Card for download as a `.smart-health-card` file (required method)
    * issuer hosts a Health Card for [FHIR API access](OperationDefinition-patient-i-health-cards-issue.json) via a compatible Health Wallet application. This workflow includes a SMART on FHIR authorization step with an Issuer, where the user grants read access to any resources that will be present in Health Cards (e.g., `Patient`, `Immunization`, `Observation`, `DiagnosticReport`)
* **User Saves** a Health Card, whether on paper or digitally.
* **User Presents** a Health Card to a Verifier. Presentation includes explicit user opt-in and approval, and may involve displaying a QR code, sharing a file, or using an on-device SDK (e.g., for verifier-to-holder app-to-app communications)

<p></p>

### Trust

Anyone can _issue_ Health Cards, and every verifier can make its own decision about which issuers to _trust_. A "trust framework"&ndash;a set of rules that helps verifiers decide which issuers to trust&ndash;can help verifiers to externalize these decisions and drive toward more consistent practices. The SMART Health Cards IG is designed to operate independent of any trust framework, while allowing trust frameworks to be layered on top. We anticipate such frameworks will emerge to meet different jurisdictional and use case driven requirements. In all cases, verifiers can discover public keys associated with an issuer via `/.well-known/jwks.json` URLs.

<p></p>

### Privacy

<p></p>

#### Data Minimization

It is an explicit design goal to let the holder **only disclose a minimum amount of information** to a verifier. The information _required_ to be disclosed is use-case dependent, and -- particularly in a healthcare setting -- it can be difficult for lay people to judge which data elements are necessary to be shared.

The granularity of information disclosure will be at the level of an entire credential (i.e., a user can select "which cards" to share from a Health Wallet, and each card is shared wholesale). The credentials are designed to only include the minimum information necessary for a given use case.

<p></p>

#### Granular Sharing

Data holders should have full control over the data they choose to share for a particular use-case. Since Health Cards are signed by the issuer and cannot be altered later, it is important to ensure that Health Cards are created with granular sharing in mind. Therefore, issuers SHOULD only combine distinct data elements into a Health Card when a Health Card FHIR profile requires it.

Commonly, Health Cards will be created to convey information about a specific disease. In such cases, Health Card FHIR Profiles SHOULD only include data that need to be conveyed together. (e.g., immunizations for different diseases should be kept separate. Immunizations and lab results should be kept separate. Immunizations and immunization exemption status should be kept separate.)

In other cases, Health Cards may be created to convey a broader set of clinical information, such as a patient summary document that can be shared in a clinical setting. In these cases, standard FHIR profiles such as [International Patient Summary](https://hl7.org/fhir/uv/ips) should guide the decision about which data to include.

<p></p>

#### Future Considerations

If we identify *optional* data elements for a given use case, we might incorporate them into credentials by including a cryptographic hash of their values instead of embedding values directly. Longer term we can provide more granular options using techniques like zero-knowledge proofs, or by allowing a trusted intermediary to summarize results in a just-in-time fashion.

<p></p>

### Data Model for Specific Use Cases

This framework defines a general approach to **representing demographic and clinical data in FHIR**, outlined in [Modeling Verifiable Credentials in FHIR](cards-credential-modeling.html).

The data model for the Health Card payload at `.vc.credentialSubject.fhirBundle` is specific to a given use case (e.g., a COVID-19 immunization card). These use case-specific details are not included as part of this framework. Instead, they are described in use case-specific FHIR Implementation Guides:

<table class="grid">
    <tbody>
	  <tr>
		<th><b>Use Case</b></th>
		<th><b>FHIR Implementation Guide</b></th>
  	  </tr>
	  <tr>
		<td>Vaccination records and laboratory testing status for infectious diseases</td>
		<td><a href="https://build.fhir.org/ig/HL7/fhir-shc-vaccination-ig">SMART Health Cards: Vaccination & Testing Implementation Guide</a>/</td>
  	  </tr>
  	  <tr>
		<td>Health insurance card information including payer, beneficiary and coverage details</td>
		<td><a href="https://hl7.org/fhir/us/insurance-card">CARIN Digital Insurance Card Implementation Guide</a>/</td>
  	  </tr>
	</tbody>
  </table>
<p></p>


<p></p>

## Protocol Details

### Generating and resolving cryptographic keys

The following key types are used in the Health Cards Framework:

* Elliptic Curve keys using the P-256 curve

<p></p>

#### Signing *Health Cards*

* Issuers sign Health Card VCs (Verifiable Credentials) with a signing key (private key)
* Issuers publish the corresponding public key (public key) at `/.well-known/jwks.json`
* Wallets and Verifiers use the public key to verify Issuer signatures on Health Cards

<p></p>

#### Determining keys associated with an issuer

Each public key used to verify signatures is represented as a JSON Web Key (see [RFC7517](https://tools.ietf.org/html/rfc7517)), with some of its properties encoded using base64url (see section 5 of [RFC4648](https://tools.ietf.org/html/rfc4648#section-5)):

* SHALL have `"kty": "EC"`, `"use": "sig"`, and `"alg": "ES256"`
* SHALL have `"kid"` equal to the base64url-encoded SHA-256 JWK Thumbprint of the key (see [RFC7638](https://tools.ietf.org/html/rfc7638))
* SHALL have `"crv": "P-256`, and `"x"`, `"y"` equal to the base64url-encoded values for the public Elliptic Curve point coordinates (see [RFC7518](https://tools.ietf.org/html/rfc7518#section-6.2))
* SHALL NOT have the Elliptic Curve private key parameter `"d"`
* If the issuer has an X.509 certificate for the public key, SHALL have `"x5c"` equal to an array of one or more base64-encoded (_not_ base64url-encoded) DER representations of the public certificate or certificate chain (see [RFC7517](https://tools.ietf.org/html/rfc7517#section-4.7)).
The public key listed in the first certificate in the `"x5c"` array SHALL match the public key specified by the `"crv"`, `"x"`, and `"y"` parameters of the same JWK entry.
If the issuer has more than one certificate for the same public key (e.g. participation in more than one trust community), then a separate JWK entry is used for each certificate with all JWK parameter values identical except `"x5c"`.

Issuers SHALL publish their public keys as JSON Web Key Sets (see [RFC7517](https://tools.ietf.org/html/rfc7517#section-5)), available at `<<iss value from JWS>>` + `/.well-known/jwks.json`, with [Cross-Origin Resource Sharing (CORS)](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Origin) enabled, using TLS version 1.2 following the IETF [BCP 195](https://www.rfc-editor.org/info/bcp195) recommendations or TLS version 1.3 (with any configuration).

The URL at `<<iss value from JWS>>` SHALL use the `https` scheme and SHALL NOT include a trailing `/`. For example, `https://smarthealth.cards/examples/issuer` is a valid `iss` value (`https://smarthealth.cards/examples/issuer/` is **not**).

**Signing keys** in the `.keys[]` array can be identified by `kid` following the requirements above (i.e., by filtering on `kty`, `use`, and `alg`).

For example, the following is a fragment of a `jwks.json` file with one signing key:
```json
{
  "keys":[
    {
      "kty": "EC",
      "kid": "_IY9W2kRRFUigDfSB9r8jHgMRrT0w4p5KN93nGThdH8",
      "use": "sig",
      "alg": "ES256",
      "crv": "P-256",
      "x": "7xbC_9ZmFwKqOHpwX6-LnlhIh5SMIuNwl0PW1yVI_sk",
      "y": "7k2fdIRNDHdf93vL76wxdXEPtj_GiMTTyecm7EUUMQo",
    }
  ]
}
```

<p></p>

#### Certificates

X.509 certificates can be used by issuers to indicate the issuer's participation in a PKI-based trust framework.

If the Verifier supports PKI-based trust frameworks and the Health Card issuer includes the `"x5c"` parameter in matching JWK entries from the `.keys[]` array,
the Verifier establishes that the issuer is trusted as follows:

1. Verifier validates the leaf certificate's binding to the Health Card issuer by:
    * matching the `<<iss value from JWS>>` to the value of a `uniformResourceIdentifier`
    entry in the certificate's Subject Alternative Name extension
    (see [RFC5280](https://tools.ietf.org/html/rfc5280#section-4.2.1.6)), and
    * verifying the signature in the Health Card using the public key in the certificate.
2. Verifier constructs a valid certificate path of unexpired and unrevoked certificates to one of its trusted anchors
 (see [RFC5280](https://tools.ietf.org/html/rfc5280#section-6)).

<p></p>

#### Key Management

Issuers SHOULD generate new signing keys at least annually.

When an issuer generates a new key to sign Health Cards, the public key SHALL be added to the
issuer's JWK set in its `jwks.json` file. Retired private keys that are no longer used to sign Health Cards SHALL be destroyed.
Older public key entries that are needed to validate previously
signed Health Cards SHALL remain in the JWK set for as long as the corresponding Health Cards
are clinically relevant. However, if a private signing key is compromised, then the issuer SHALL immediately remove the corresponding public key from the JWK set in its `jwks.json` file and request revocation of all X.509 certificates bound to that public key; verifiers will from then on reject all Health Cards signed using that key.

<p></p>

#### Revocation

Individual Health Cards MAY be revoked using a revocation identifier property `rid` encoded in the `vc` claim of the JWT. This should be a short identifier, meaningless to the verifiers; the only constraint is that the identifier SHALL use the base64url alphabet (but doesn’t need to be base64url encoded, see section 5 of [RFC4648](https://tools.ietf.org/html/rfc4648#section-5)) and be no longer than 24 characters. Issuers MAY use application-specific user identifiers for this purpose, but since these could be publicly listed in revocation lists, issuers SHOULD use a one-way transformation of the data combined with enough entropy to prevent reversal. It is RECOMMENDED to use the base64url encoding of the first 64 bits of the output of HMAC-SHA-256 (as specified in [RFC4868](https://tools.ietf.org/html/rfc4868)) on the user identifier using a 256-bit random secret key concatenated with the `<<kid>>`; i.e.,

```
rid = base64url(hmac-sha-256(secret_key || <<kid>>, user_id)[1..64]).
```
The revocation HMAC secret can be generated once and reused for all the issuer keys and issued Health Cards. If an issuer chooses to change the secret, old values need to be remembered in order to re-calculate previously generated `rid`.

To enable per-card revocation, the issuer creates, for each of its keys, a JSON Card Revocation List (CRL) file with the following content:
```json
{
"kid": "<<kid>>",
"method": "rid",
"ctr": "<<ctr>>",
"rids": [...]
}
```

where

* `"<<kid>>"` is the ID of the corresponding issuer key,
* `"rid"` identifies the revocation method specified in this framework; legacy cards can use different methods specified in external revocation profiles,
* `"<<ctr>>"` is a counter indicating how many times this file has been updated; initial value is 1,
*  `rids` is an array of revoked cards' identifiers `rid` values. These values are represented as strings from the base64url alphabet, plus an optional timestamp suffix consisting of `.` followed by a numerical timestamp (e.g., `.1636977600`)

To revoke a Health Card issued under the key `"<<kid>>"`, an issuer adds its revocation identifier to the `rids` array of the corresponding `<<kid>>`'s revocation file. Since an issuer might want to invalidate a series of Health Cards associated with the user up to a certain time, the `rid` might be followed by a separator `.` a timestamp (encoded as the number of seconds from 1970-01-01T00:00:00Z UTC, as specified by [RFC7519](https://tools.ietf.org/html/rfc7519)). After updating the `rids` array (with one or more items), the `<<ctr>>` is incremented.

As an example, the `rids` array `["AQPCj4wwk6Mt", "lHKzqFUMjhs.1636977600"]` marks as revoked any Health Cards with `rid` equal to `AQPCj4wwk6Mt` and Health Cards with `rid` equal to `lHKzqFUMjhs` issued before November 15, 2021 12:00:00 PM GMT.

The per-key revocation file is made available at `https://"<<Issuer URL>>"/.well-known/crl/"<<kid>>".json`, where

* `"<<Issuer URL>>"` is the issuer URL listed in the Health Card,
* `"<<kid>>"` is the key ID with which the Health Card was signed.

Issuers supporting this revocation method SHALL include in their published JWK set, for each key, a `crlVersion` field encoding the update counter "<<ctr>>" for the corresponding revocation file.

If the `crlVersion` is present in the Issuer's JWK for key `<<kid>>`, Verifiers SHALL

* Download the `https://"<<Issuer URL>>"/.well-known/crl/"<<kid>>".json` file or use a cached version if the counter value has not changed since the last retrieval,
* Reject the Health Card if the calculated `rid` is contained in the CRL's `rids` array and (if a timestamp suffix is present) the Health Card’s `nbf` is value is before the timestamp.

Revocation of Health Cards without a `rid` field (including all pre-v1.2.0 ones) can be done using external mechanisms to calculate a dynamic `rid` value based on the JWS’s content.

If revocation is desired and individual revocation of SMART Health Cards is not possible, the issuer has the option of revoking its issuing key and allowing users to obtain new Health Cards. Limiting the validity period of a key helps to mitigate the adverse effects of this situation. See the [revocation FAQ](frequently-asked-questions.html#what-are-methods-for-revoking-smart-health-cards) for more details.

<p></p>

### Issuer Generates Results

When the issuer is ready to generate a Health Card, the issuer creates a FHIR payload and packs it into a corresponding Health Card VC (or Health Card Set).


<div>
<figure class="figure">
<figcaption class="figure-caption"><strong><i>Issuer Generates a Health Card</i></strong></figcaption>
  <br />
  <p>
  <img src="issuer-generates-results.png" style="float:none; width:500px">  
  </p>
</figure>
</div>

<p></p>

#### Health Cards are encoded as Compact Serialization JSON Web Signatures (JWS)

The VC structure (scaffold) is shown in the following example. The Health Cards framework serializes VCs using the compact JWS serialization, where the payload is a compressed set of JWT claims (see [Appendix 3 of RFC7515](https://tools.ietf.org/html/rfc7515#appendix-A.3) for an example using ECDSA P-256 SHA-256, as required by this specification). Specific encoding choices ensure compatibility with standard JWT claims, as described at [https://www.w3.org/TR/vc-data-model/#jwt-encoding](https://www.w3.org/TR/vc-data-model/#jwt-encoding).

The `type`, and `credentialSubject` properties are added to the `vc` claim of the JWT. The `type` values are defined in [Credential Types](https://terminology.smarthealth.cards/CodeSystem-health-card.html); the `https://smarthealth.cards#health-card` SHALL be present; other types SHOULD be included when they apply. Verifiers and other entities processing SMART Health Cards SHALL ignore any additional `type` elements they do not understand. The `issuer` property is represented by the registered JWT `iss` claim and the `issuanceDate` property is represented by the registered JWT `nbf` ("not before") claim (encoded as the number of seconds from 1970-01-01T00:00:00Z UTC, as specified by [RFC7519](https://tools.ietf.org/html/rfc7519)). Hence, the overall JWS payload matches the following structure (before it is [minified and compressed](#health-cards-are-compact)):

```json
{
  "iss": "<<Issuer URL>>",
  "nbf": 1591037940,
  "vc": {
    "type": [
      "https://smarthealth.cards#health-card",
      "<<Additional Types>>",
    ],
    "credentialSubject": {
      "fhirVersion": "<<FHIR Version, e.g. '4.0.1'>>",
      "fhirBundle":{
        "resourceType": "Bundle",
        "type": "collection",
        "entry": ["<<FHIR Resource>>", "<<FHIR Resource>>", "..."]
      }
    }
  }
}
```

<p></p>

#### Health Cards are Compact

Issuers SHALL ensure that the following constraints apply at the time of issuance:

* JWS Header
    * header includes `alg: "ES256"`
    * header includes `zip: "DEF"`
    * header includes `kid` equal to the base64url-encoded (see section 5 of [RFC4648](https://tools.ietf.org/html/rfc4648#section-5)) SHA-256 JWK Thumbprint of the key (see [RFC7638](https://tools.ietf.org/html/rfc7638))

* JWS Payload
    * payload is minified (i.e., all optional whitespace is stripped)
    * payload is compressed with the DEFLATE (see [RFC1951](https://www.ietf.org/rfc/rfc1951.txt)) algorithm before being signed (note, this should be "raw" DEFLATE compression, omitting any zlib or gz headers)

<div style="margin-left:40px">
<a name="card-content-minified"></a>
<h5>Payload content minified for QR codes</h5>
For Health Cards that will be directly represented as QR codes, issuers SHALL ensure that content is minified as follows:
<p></p>
<div style="margin-left:20px">
JWS payload `.vc.credentialSubject.fhirBundle` is created...
  <ul>
    <li>without `Resource.id` elements</li>
    <li>without `Resource.meta` elements (or if present, `.meta.security` is included and no other fields are included)</li>
    <li>without `DomainResource.text` elements</li>
    <li>without `CodeableConcept.text` elements</li>
    <li>without `Coding.display` elements</li>
    <li>with `Bundle.entry.fullUrl` populated with short `resource`-scheme URIs (e.g., `{"fullUrl": "resource:0"}`)</li>
    <li>with `Reference.reference` populated with short `resource`-scheme URIs (e.g., `{"patient": {"reference": "resource:0"}}`)</li>
  </ul>
  </div>
</div>

For details about how to represent a Health Card as a QR code, [see below](#health-cards-as-qr-codes).

<p></p>

### User Retrieves Health Cards

In this step, the user learns that a new Health Card is available (e.g., by receiving a text message or email notification, or by an in-wallet notification for FHIR-enabled issuers.)

<p></p>

#### via File Download

To facilitate this workflow, the issuer can include a link to help the user download the credentials directly, e.g., from a login-protected page in the Issuer's patient portal. The file SHALL be served with a `.smart-health-card` file extension and SHALL be provided with a MIME type of `application/smart-health-card` (e.g., web servers SHALL include `Content-Type: application/smart-health-card` as an HTTP Response containing a Health Card), so the Health Wallet app can be configured to recognize this extension and/or MIME type. Contents SHALL be a JSON object with a verifiableCredential array containing one or more verifiable credential JWS strings:

```json
{
  "verifiableCredential": [
    "<<Verifiable Credential as JWS>>",
    "<<Verifiable Credential as JWS>>"
  ]
}
```

<p></p>

#### via QR (Print or Scan)

Alternatively, issuers can represent an individual JWS inside a Health Card available **as a QR code** (for instance, printed on a paper-based vaccination record or after-visit summary document). See [details](#health-cards-as-qr-codes).

Finally, the Health Wallet asks the user if they want to save any/all of the supplied credentials.

<p></p>

#### via "Deep Link"

For a user to import one or more SMART Health Cards to their Health Wallet with one tap or click, issuers can display app-specific "deep links". These are available on most modern operating systems and will open in a native app if the respective app is installed on the computer or smartphone.

Apps can define their own deep link syntax. However, for consistency we recommend Health Wallets support the following format, which re-uses the JSON format defined for [file download](#via-file-download):

```
<<app-specific deep link base URL>>#{"verifiableCredential":["<<Verifiable Credential as JWS>>"<<','0+ more JWS>>]}
```

To follow this recommendation, deep link base URLs SHALL use a secure protocol (e.g., `https://`), and SHOULD end with `/SMARTHealthCard/`.
   
Note that the recommended format serves the JWS content in a `#` fragment to ensure that no data is transmitted to the server in the event that an app-specific deep link is opened in a browser context (e.g., on a device where the app has not been installed).

For a concrete example, consider an app whose deep link base is `https://app.example.com/i/SMARTHealthCard/`. A deep link to import two SMART Health Cards into the app would look something like this (actual JWS payload shortened for readability):

```text
https://app.example.com/i/SMARTHealthCard/#{"verifiableCredential":["eyJhbGc.dVPBbtswDP.Xo3dhlA","eyJhbGc.xVVNc9MwEP.B3KT7OD"]}
```

With proper URL encoding a link will look like:

```html
<a href="https://app.example.com/i/SMARTHealthCard/#%7B%22verifiableCredential%22%3A%5B%22eyJhbGc.dVPBbtswDP.Xo3dhlA%22%2C%22eyJhbGc.xVVNc9MwEP.B3KT7OD%22%5D%7D">
  Link Text
</a>
```

After OS-mediated redirection, the Health Wallet app can now parse each JWS and present the collection for import to the user.

<p></p>

#### via FHIR `$health-cards-issue` Operation

For a more seamless user experience when FHIR API connections are already in place, results may also be conveyed through a FHIR API `$health-cards-issue` operation defined [here](OperationDefinition-patient-i-health-cards-issue.html). For issuers that support SMART on FHIR access, the Health Wallet MAY request authorization with SMART on FHIR scopes (e.g., `launch/patient patient/Immunization.read` for an Immunization use case). This allows the Health Wallet to automatically request issuance of VCs, including requests for periodic updates.

<p></p>

#### Discovery of FHIR Support

A SMART on FHIR Server capable of issuing VCs according to this specification SHALL advertise its support by adding the `health-cards` capability to its `/.well-known/smart-configuration` JSON file. For example:

```json
{
  "authorization_endpoint": "https://ehr.example.com/auth/authorize",
  "token_endpoint": "https://ehr.example.com/auth/token",
  "token_endpoint_auth_methods_supported": ["client_secret_basic"],
  "scopes_supported": ["launch", "launch/patient", "patient/*.*", "offline_access"],
  "response_types_supported": ["code", "code id_token", "id_token", "refresh_token"],
  "capabilities": ["health-cards", "launch-standalone", "context-standalone-patient", "client-confidential-symmetric"]
}
```

<p></p>

### Presenting Health Cards to a Verifier

In this step, the verifier asks the user to share a Health Card. A Health Card
containing the result can be conveyed by presenting a QR code; by uploading a
file; or by leveraging wallet-specific APIs.

When a wallet-specific API is used to manage this sharing workflow, the API
SHOULD ensure that the requester can specify filters for:

1. SMART Health Card resource types, to restrict the request based on FHIR
Resource Types such as "Immunization" or "Observation". See [FHIR Resource
Types](https://hl7.org/fhir/R4/resourcelist.html).  Type-based filters evalute
Health Cards based on the FHIR resource types within the Health Card payload at
`.vc.credentialSubject.fhirBundle.entry[].resource`.

1. SMART Health Card value sets, to further restrict the request by FHIR
content such as "any standardized vaccine code for mpox". See [Health Card
ValueSets](https://terminology.smarthealth.cards/artifacts.html#terminology-value-sets).
Valueset-based filters apply to the FHIR Resources within the Health Card
payload at `.vc.credentialSubject.fhirBundle.entry[].resource`.  For
Immunizations, the `Immunization.vaccineCode` is evaluated. For
Observations, the `Observation.code` is evaluated.

This same filtering approach is used by the [`$health-cards-issue`
operation](#via-fhir-health-cards-issue-operation), via the `credentialType`
and `credentialValueSet` parameters. Over time, we will endeavor to provide
more standardized presentation workflows for on-device and web-based exchange.

<p></p>

### Health Cards as QR Codes

Each JWS string that appears in the `.verifiableCredential[]` of a `.smart-health-card` file can be represented as a QR code, if the payload is small enough. We aim to ensure that printed (or electronically displayed) codes are usable at physical dimensions of 40mmx40mm. This constraint allows us to use QR codes up to Version 22, at 105x105 modules. When representing a JWS as a QR code, implementers SHALL follow the rules for [Encoding QRs](#encoding-qrs).

Ensuring Health Cards can be presented as QR codes:

* Allows basic storage and sharing of Health Cards for users without a smartphone
* Allows smartphone-enabled users to print a usable backup
* Allows full Health Card contents to be shared with a verifier

The following limitations apply when presenting Health Card as QR codes, rather than engaging in device-based workflows:

* Does not capture a digital record of a request for presentation
  * Verifier cannot include requirements in-band
  * Verifier cannot include purposes of use in-band
* Does not capture a digital record of the presentation

<p></p>

  <div  class="smart-styles-alert smart-styles-alert--deprecated ">
    <div >
      <span class="smart-styles-admonitionIcon_kALy">
        <svg viewBox="0 0 14 16">
          <path fill-rule="evenodd" d="M7 2.3c3.14 0 5.7 2.56 5.7 5.7s-2.56 5.7-5.7 5.7A5.71 5.71 0 0 1 1.3 8c0-3.14 2.56-5.7 5.7-5.7zM7 1C3.14 1 0 4.14 0 8s3.14 7 7 7 7-3.14 7-7-3.14-7-7-7zm1 3H6v5h2V4zm0 6H6v2h2v-2z"></path>
        </svg>
      </span>
      DEPRECATED
    </div>
    <b>Chunking Larger SMART Health Cards</b><br/>
<i>Deprecation note: As of December 2022, support for chunking has not been widely adopted in production SHC deployments. For SHCs that need to be presented as QRs, we recommend limiting payload size to fit in a single QR (when possible), or else considering SMART Health Links.</i>
<p></p>
Commonly, SMART Health Cards will fit in a single V22 QR code. Any JWS longer than 1195 characters SHALL be split into "chunks" of length 1191 or smaller; each chunk SHALL be encoded as a separate QR code of V22 or lower, to ensure ease of scanning. Each chunk SHALL be numerically encoded and prefixed with an ordinal as well as the total number of chunks required to re-assemble the JWS, as described below. The <a href="https://github.com/smart-on-fhir/health-cards/blob/main/FAQ/qr.md">QR code FAQ page</a> details max JWS length restrictions at various error correction levels.
<p></p>
To ensure the best user experience when producing and consuming multiple QR codes:
    <ul>
      <li>Producers of QR codes SHOULD balance the sizes of chunks. For example, if a JWS is 1200 characters long, producers should create two ~600 character chunks rather than a 1191 character chunk and a 9 character chunk.</li>
      <li>Consumers of QR codes SHOULD allow for scanning the multiple QR codes in any order. Once the full set is scanned, the JWS can be assembled and validated.</li>
    </ul>
</div>

<p></p>

#### Encoding QRs

When printing or displaying a Health Card using QR codes, let "N" be the total number of chunks required, and let "C" be a variable indicating the index of the current chunk. Each chunk of the JWS string value SHALL be represented as a QR with two data segments:

<ol>
   <li>
      A segment encoded with <code class=" highlighter-rouge language-plaintext">bytes</code> mode consisting of
      <ul>
         <li>the fixed string <code class=" highlighter-rouge language-plaintext">shc:/</code> (registered as an <a href="https://www.iana.org/assignments/uri-schemes/prov/shc">IANA scheme</a>)</li>
      </ul>
   </li>
   <div  class="smart-styles-alert smart-styles-alert--deprecated ">
      <div >
         <span class="smart-styles-admonitionIcon_kALy">
            <svg viewBox="0 0 14 16">
               <path fill-rule="evenodd" d="M7 2.3c3.14 0 5.7 2.56 5.7 5.7s-2.56 5.7-5.7 5.7A5.71 5.71 0 0 1 1.3 8c0-3.14 2.56-5.7 5.7-5.7zM7 1C3.14 1 0 4.14 0 8s3.14 7 7 7 7-3.14 7-7-3.14-7-7-7zm1 3H6v5h2V4zm0 6H6v2h2v-2z"></path>
            </svg>
         </span>
         DEPRECATED
      </div>
      <ul>
         <li>
            plus (only if more than one chunk is required; note this feature is deprecated): 
            <ul>
               <li>decimal representation of “C” (e.g., <code class=" highlighter-rouge language-plaintext">1</code> for the first chunk, <code class=" highlighter-rouge language-plaintext">2</code> for the second chunk, and so on)</li>
               <li>plus the fixed string <code class=" highlighter-rouge language-plaintext">/</code></li>
               <li>plus decimal representation of “N” (e.g., <code class=" highlighter-rouge language-plaintext">2</code> if there are two chunks in total, <code class=" highlighter-rouge language-plaintext">3</code> if there three chunks in total, and so on)</li>
               <li>plus the fixed string <code class=" highlighter-rouge language-plaintext">/</code></li>
            </ul>
         </li>
      </ul>
   </div>
   <p></p>
   <li>A segment encoded with <code class=" highlighter-rouge language-plaintext">numeric</code> mode consisting of the characters <code class=" highlighter-rouge language-plaintext">0</code>-<code class=" highlighter-rouge language-plaintext">9</code>. Each character “c” of the JWS is converted into a sequence of two digits as by taking <code class=" highlighter-rouge language-plaintext">Ord(c)-45</code> and treating the result as a two-digit base ten number. For example, <code class=" highlighter-rouge language-plaintext">'X'</code> is encoded as <code class=" highlighter-rouge language-plaintext">43</code>, since <code class=" highlighter-rouge language-plaintext">Ord('X')</code> is <code class=" highlighter-rouge language-plaintext">88</code>, and <code class=" highlighter-rouge language-plaintext">88-45</code> is <code class=" highlighter-rouge language-plaintext">43</code>. (The constant “45” appears here because it is the ordinal value of <code class=" highlighter-rouge language-plaintext">-</code>, the lowest-valued character that can appear in a compact JWS. Subtracting 45 from the ordinal values of valid JWS characters produces a range between 00 and 99, ensuring that each character of the JWS can be represented in exactly two base-10 numeric digits.)</li>
</ol>


(The reason for representing Health Cards using Numeric Mode QRs instead of Binary Mode (Latin-1) QRs is information density: with Numeric Mode, 20% more data can fit in a given QR, vs Binary Mode. This is because the JWS character set conveys only log_2(65) bits per character (~6 bits); binary encoding requires log_2(256) bits per character (8 bits), which means ~2 wasted bits per character.)

For example:

<ul>
  <li>a single chunk might produce a QR code like <code class=" highlighter-rouge language-plaintext">shc:/56762909524320603460292437404460</code> &lt;snipped for brevity&gt;</li>
</ul>

  <div  class="smart-styles-alert smart-styles-alert--deprecated ">
    <div >
      <span class="smart-styles-admonitionIcon_kALy">
        <svg viewBox="0 0 14 16">
          <path fill-rule="evenodd" d="M7 2.3c3.14 0 5.7 2.56 5.7 5.7s-2.56 5.7-5.7 5.7A5.71 5.71 0 0 1 1.3 8c0-3.14 2.56-5.7 5.7-5.7zM7 1C3.14 1 0 4.14 0 8s3.14 7 7 7 7-3.14 7-7-3.14-7-7-7zm1 3H6v5h2V4zm0 6H6v2h2v-2z"></path>
        </svg>
      </span>
      DEPRECATED
    </div>
    <ul>
      <li>in a longer JWS, the second chunk in a set of three might produce a QR code like: <code class=" highlighter-rouge language-plaintext">shc:/2/3/56762909524320603460292437404460 &lt;snipped for brevity&gt;</code> 
      <br/>(note this feature is deprecated)</li>
    </ul>
</div>

<p></p>

### Expiration of Health Cards

SMART Health Cards contain factual information that is assured to be correct at the point of issuance and does not change with the passage of time. Therefore, **Health Cards generally do not expire** and an expiration date is not used. There are, however, situations where the ability to set an expiration date is beneficial.

One use case for issuing SMART Health Cards with an expiration date is a government entity issuing a vaccination card to foreign visitors for their use while in the destination country. This visitor's vaccination card is issued based on original documents presented by the visitor. Even with robust verification protocols, the government entity may not want to vouch for the validity of the visitor pass for an unlimited period of time. Importantly, the original document may be invalidated at some point in the future, e.g. by its signing keys being revoked. It may be impractical for the government entity issuing the visitor pass to track and reactively revoke the visitor pass. This risk can be mitigated by setting an expiration date on the visitor pass at the time of issuance. The expiration date could, for example, correspond to the visitor's allowed duration of stay in the foreign country.

To address use cases such as the preceding one, an optional SMART Health Card expiration date can be represented by the registered JWT `exp` claim (encoded as the number of seconds from 1970-01-01T00:00:00Z UTC, as specified by [RFC7519](https://tools.ietf.org/html/rfc7519)). Verifiers SHALL check the expiration, if present, and reject SMART Health Cards with an `exp` value that is before the current verification date-time.

<p></p>

### Examples

See the [examples page](cards-examples.html) for examples of SMART Health Cards and components.

<p></p>

### Potential Extension: Standardized presentation workflows

The spec is currently focused on representing Health Cards in a standardized data payload. This allows many simple patterns for sharing, but future work can introduce standardized presentation exchange flows (e.g., OpenID Self-Issued Identity Provider, a.k.a. SIOP)

<p></p>

### Historical Requests for Comment (RFCs)

For historical reference, past Requests for Comments related to SMART Health Cards can be found on this [RFC page](https://github.com/smart-on-fhir/health-cards/tree/main/rfcs) in the SMART Health Cards GitHub.

<p></p>

### References


* Fast Health Interoperability Resources (FHIR): [https://hl7.org/fhir/](https://hl7.org/fhir/)
* DEFLATE Compression: [https://tools.ietf.org/html/rfc1951](https://tools.ietf.org/html/rfc1951)
* JSON Web Token (JWT): [https://tools.ietf.org/html/rfc7519](https://tools.ietf.org/html/rfc7519)
* JSON Web Key (JWK): [https://tools.ietf.org/html/rfc7517](https://tools.ietf.org/html/rfc7517)
* JSON Web Key (JWK) Thumbprint: [https://tools.ietf.org/html/rfc7638](https://tools.ietf.org/html/rfc7638)
* HMAC-SHA-256: [https://tools.ietf.org/html/rfc4868](https://tools.ietf.org/html/rfc4868)

<p></p>
<p></p>