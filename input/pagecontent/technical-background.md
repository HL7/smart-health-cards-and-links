_Source content from the Health Card site's Specification page, except where noted:_

<p></p>

### Health Cards Conceptual Model

<div>
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

<hr>

_Source content from the Health Links site's Design Overview page:_

<p></p>

* Allow sharing of tamper-proof data
* Allow sharing of non-tamper-proof data
* Allow long-term sharing of data
* Allow sharing data that can evolve over time
* Mitigate the damage of QRs being leaked or scanned by the wrong party
  * Allow generate of "one-time use" QR (or a limited-time use QR), so at the time of creation there's a limited number of "claims" or a limited time period attached to it
  * Allow protecting the QR with a PIN, which the Sharer can communicate the PIN to the Recipient out-of-band
* Give Data Sharers the option to host files using encrypted cloud storage, so the hosting provider can't see file contents. (This is mainly important in cases where the data originates from a clinical data system but passes through the consumer's hands and then is hosted online in a cloud service of the consumer's choice. For example, a consumer health app might periodically upload a "most recent labs" file compiled from various sources, and the consumer shouldn't need to trust the file hosting service to actually see plaintext lab results.)
* Offer a simple UX where Data Recipients can scans a QR and immediately retrieve the data
* Offer a glide path for upgraded assurance, e.g. allowing Data Sharers to define a PIN or even (someday) require the Data Recipient party to authenticate or id-proof before accessing shared data

<p></p>

_end of Smart Links Design Overview content_
<hr>

<p></p>

### Use Cases
<hr>

_Source content from the Health Links site's Design Overview page:_

* Share a link to any collection of FHIR data, including signed data
* Share link to a static SMART Health Card that's too big to fit in a QR
* Share link to a "dynamic" SMART Health Card -- i.e., a file that can evolve over time (e.g., "my most recent COVID-19 lab results")
* Share a link to Bundles of patient-supplied data (e.g., "my advance directive" to share with EMS, or "my at-home weight measurements" to share with a weight loss program, or "my active prescriptions" to share with a service that helps you find better drug prices)
  * Note that for specific use cases, these data don't need to be tamper-proof, and could be aggressively stripped down (e.g., for a drug pricing service, just the drug codes and dosage would go a long way)
* Provision access to a patient's SMART on FHIR API endpoint (e.g., "I'm going to see a specialist and by presenting a single QR, I can give them access to the FHIR API from my primary care provider's portal")

_end of Smart Links Design Overview content_
<hr>

### Approach: Start Small -- Think Big

We enable Health Cards by defining building blocks that can be used across healthcare. The core building block allows us to aggregate data into meaningful sets, signed by an issuer, and stored/presented by a consumer as needed. The broader set of use cases should eventually include:

* Managing an immunization record that can be shared with schools or employers, or for travel
* Sharing verifiable health history data with clinical research studies
* Sharing voluntary data with public health agencies
* Sharing questionnaire responses with healthcare providers

When we launched the project, our short-term definition of success included:

* Represent "Health Cards" in a "Health Wallet", focusing on COVID-19 status
* Ensure that each role (issuer, holder, app) can be implemented by any organization following open standards, provided they sign on to the relevant trust framework

<p></p>

### User Experience and Data Flow

* **User Receives** a Health Card from an Issuer. The Health Card is a signed data artifact that the user can obtain through any of these methods:
    * issuer offers a Health Card on paper or PDF, including a QR code (required method)
    * issuer offers a Health Card for download as a `.smart-health-card` file (required method)
    * issuer hosts a Health Card for [FHIR API access](cards-specification.html#healthwalletissuevc-operation) via a compatible Health Wallet application. This workflow includes a SMART on FHIR authorization step with an Issuer, where the user grants read access to any resources that will be present in Health Cards (e.g., `Patient`, `Immunization`, `Observation`, `DiagnosticReport`)
* **User Saves** a Health Card, whether on paper or digitally.
* **User Presents** a Health Card to a Verifier. Presentation includes explicit user opt-in and approval, and may involve displaying a QR code, sharing a file, or using an on-device SDK (e.g., for verifier-to-holder app-to-app communications)

<p></p>

### Trust

Anyone can _issue_ Health Cards, and every verifier can make its own decision about which issuers to _trust_. A "trust framework" can help verifiers to externalize these decisions and drive toward more consistent practices. The SMART Health Cards IG is designed to operate independent of any trust framework, while allowing trust frameworks to be layered on top. We anticipate such frameworks will emerge to meet different jurisdictional and use case driven requirements. In all cases, verifiers can discover public keys associated with an issuer via `/.well-known/jwks.json` URLs.

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
	</tbody>
  </table>
<p></p>


<p></p>

### Potential Extension: Standardized presentation workflows

The spec is currently focused on representing Health Cards in a standardized data payload. This allows many simple patterns for sharing, but future work can introduce standardized presentation exchange flows (e.g., OpenID Self-Issued Identity Provider, a.k.a. SIOP)

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