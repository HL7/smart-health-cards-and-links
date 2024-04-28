### Overview

Paper medical records--such as vaccination histories and insurance cards--are easily lost or damaged, are difficult to authenticate, and are often not on-hand when they’re needed. 

SMART Health Cards and Links are FHIR-based standards that address these challenges, enabling individuals to receive their health information and share it with others in a tamper-proof and verifiable digital form.They provide a digital version of an individual's clinical information that can be kept at the ready and easily shared with others when the need arises--using a QR code, mobile app or web browser.


* [SMART Health Cards](cards-user-stories.html) allow an individual to keep a copy of their important health records with them and easily share this information with others. They contain a secure QR code and may be saved digitally or printed on paper. SMART Health Cards build on international open standards and decentralized infrastructure to provide end-user privacy and the ability to work across organizational and jurisdictional boundaries

* [SMART Health Links](links-user-stories.html) add the ability to store and share more information than can be kept on a single SMART Health Card, and provide sharing options including limited-time access, long-term sharing of data that can evolve over time, and protecting access with a PIN that can be communicated to the recipient out-of-band.

Together SMART Health Cards and Links provide options that support multiple goals--from keeping a small amount of verifiable medical information close by to authorizing a trusted party to access their entire medical record. They empower individuals with secure, equitable, and privacy-preserving access to their clinical information.

<p></p>

Examples of what an individual can do using these standards include:

- receive proof of critical immunizations on a physical card or in a mobile app and allow others to verify them by scanning the attached QR code
- scan their insurance card's QR code when checking in at their doctor's office--transmitting their member ID and other coverage information directly to the clinic's system
- send an elementary school a link to their child's immunization history, allowing the school to verify the information with the immunization registry and copy in the details if it wishes
- receive a "ticket" to access the results of a lab test when they're ready
- give a provider time-limited or ongoing access to some or all of their medical data, including the ability to search.

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