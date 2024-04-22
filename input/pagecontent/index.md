### Overview

Paper medical records, such as vaccination records or insurance cards, are easily lost or  damaged, and are often not on-hand when they're needed. Paper records are also difficult to authenticate, creating concerns about forgeries in situations such as the COVID-19 pandemic.

SMART Health Cards and SMART Health Links are FHIR-based standards that address these challenges, enabling patients to receive their health information and share it with others in a tamper-proof and verifiable digital form, using QR codes, mobile apps and web sites. 

Together SMART Health Cards and Links provide options that support different patient goals--from keeping a small amount of verifiable medical information on-hand to authorizing a trusted party to access their entire medical record. 

<p></p>

Examples of what an individual can do using these standards include:

- receive proof of critical immunizations on a physical card or in a mobile app and allow others to verify them by scanning the attached QR code
- scan their insurance card's QR code when checking in at their doctor's office--transmitting their member ID and other coverage information directly to the clinic's system
- send an elementary school a link to their child's immunization history, allowing the school to verify the information with the immunization registry and copy in the details if it wishes
- receive a "ticket" to access the results of a lab test when they're ready
- give a provider time-limited or ongoing access to some or all of their medical data, including the ability to search.

<p></p>

SMART Health Cards and Links share technologies for representing, securing and verifying a patient's information and are designed to be used together. This guide defines their features, specifies rules for implementing, and describes scenarios that illustrate their use.

<p></p>

### SMART Health Cards

Health Cards are verified versions of an individual's clinical information, such as vaccination history or test results. They allow a patient to keep a copy of their important health records on hand and easily share this information with others. Health Cards contain a secure QR code and may be saved digitally or printed on paper.

Patients can get a Health Card through a qualified issuer. An issuer is any organization authorized by the [Verifiable Clinical Information coalition (VCI)](https://www.vci.org) to generate these cards, including pharmacies, hospitals, healthcare providers, medical labs, public health agencies, and more.

This implementation guide provides a framework for Health Cards that supports documentation of any health-related details that can be modeled with [HL7 FHIR](https://hl7.org/fhir/). This work grew out of our initial focus on enabling a consumer to receive COVID-19 Vaccination or Lab results and **present these results to another party in a verifiable manner**. Key use cases included conveying point-in-time infection status for return-to-workplace and travel.

To ensure end-user privacy and the ability for Health Cards to work across organizational and jurisdictional boundaries, this framework builds on international open standards and decentralized infrastructure.

<p></p>

### SMART Health Links
Health Links add features including...
- storage and sharing of more information than can be kept on a single Health Card
- sharing of both tamper-proof and non-tamper-proof information
- long-term sharing of data
- sharing data that can evolve over time
- mitigating the damage of QRs being leaked or scanned by the wrong party, through generation of a "one-time use" QR code (or a limited-time use QR), so at the time of creation there's a limited number of "claims" or a limited time period attached to it
- protecting the QR with a PIN, which the patient can communicate to the recipient out-of-band
- the option to host files using encrypted cloud storage, so the hosting provider can't see file contents
- a simple UX where Data Recipients can scans a QR and immediately retrieve the data
- a path to additional assurance that information is only shared with the intended party, e.g. requiring a recipient authenticate or id-proof before accessing the shared data.

<p></p>

### Content and organization
The implementation guide is organized into the following sections:
* **SMART Health Cards** [User Stories](cards-user-stories.html), formal [Specification](cards-specification.html) and the [Issue Verifiable Credential operation definition](OperationDefinition-patient-i-health-cards-issue.html)
* **SMART Health Links** [User Stories](links-user-stories.html) and formal [Specification](links-specification.html)
* **Background** section containing [technical background](technical-background.html) [examples](examples.html) and other reference information. 

<p></p>

### Dependencies 
This implementation guide relies on the following other specifications: 

*[to be added]*

<p></p>

### Contributing

*[to be updated (this is from the existing specs)]*

The SMART Health Cards specification is copyright by *Computational Health Informatics Program, Boston Children's Hospital, Boston, MA* and licensed under [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/).

We welcome discussion on the [SMART Health Cards channel](https://chat.fhir.org/#narrow/stream/284830-smart.2Fhealth-cards) of the FHIR community chat. 

_**[remove or reference HL7 jira?]**_ You can also propose changes via GitHub [Issues](https://github.com/smart-on-fhir/health-cards/issues) or create a [Pull Request](https://github.com/smart-on-fhir/health-cards/pulls).

_**[remove or ?]**_ Security issues can be disclosed privately by emailing `security@smarthealth.cards` to allow for a responsible disclosure to affected parties.


<p></p>

### Sponsoring HL7 Workgroup  
[FHIR Infrastructure](https://confluence.hl7.org/display/FHIRI)

<p></p>

### Authors

*[to be updated]*

<table class="grid">
    <tbody>
	  <tr>
		<td colspan="2">HL7 FHIR Infrastructure Work Group</td>
  	  </tr>
  	  <tr>
		<td>Frank McKinney</td>
		<td><a href="mailto:fm@frankmckinney.com">fm@frankmckinney.com</a></td>
	  </tr>
	  <tr>
		<td colspan="2"><i>[?]</i> Requirements are taken from prior Argonaut and Vaccination Credential Initiative (VCI) projects, as well as  from HL7 work groups who are interested parties</td>
  	  </tr>
	  <tr>
		<td colspan="2"><i>[?]</i> Other mention of SMART, Boston Children's or other parties?</td>
  	  </tr>
	</tbody>
  </table>

<p></p>

### Dependencies
{% include dependency-table.xhtml %}

### Cross Version Analysis
{% include cross-version-analysis.xhtml %}

### Global Profiles
{% include globals-table.xhtml %}

### IP Statements
{% include ip-statements.xhtml %}

<p></p>

*[?: Add IP statement for Boston Children's or other parties?]*

<p></p>
<p></p>