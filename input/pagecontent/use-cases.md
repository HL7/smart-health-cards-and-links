This section describes real-world situations where Cards and Links can be used by individuals to receive and share their health information.

Each use case represents a goal that can be met using Cards and Links, and its scenarios describe ways that meeting the goal might play out in real life. Each scenario illustrates a different set of circumstances and conditions and shows how Card and Link features come into play to address them. 

<p></p>

### Participants
The parties and the roles they play when information is shared using Cards and/or Links are described below.

Each role is given a common name that is used throughout the guide, and the sections below give examples of people and organizations that may play them in different situations.

<p></p>

_Discuss: Roles and our terms for them. Strawmen below_

<p></p>

#### Individual/patient
...

#### Recipient/verifier
...

#### Data issuer
...

#### Data holder/repository
... 

<p></p>
<p></p>

_Discuss how we want to define / organize our main use cases and scenarios. The strawmen below might not be the best..._

<p></p>

### Use Case: Issue verifiable health information to the individual
...

#### Scenario: Issue a Card holding verifiable information
...

#### Scenario: Issue a Link referencing information stored in the issuer's system
...

#### Scenario: Provide access to information to be captured in the future
...

### Use Case: Verify a patient's medical information
...

#### Scenario: Verify information captured within a QR code
... 

#### Scenario: Verify information referenced by a Link]
...

### [etc.]

<p></p>

<hr>

_Source content from the Health Links site's Design Overview page:_

<p></p>

### Use cases

* Share a link to any collection of FHIR data, including signed data
* Share link to a static SMART Health Card that's too big to fit in a QR
* Share link to a "dynamic" SMART Health Card -- i.e., a file that can evolve over time (e.g., "my most recent COVID-19 lab results")
* Share a link to Bundles of patient-supplied data (e.g., "my advance directive" to share with EMS, or "my at-home weight measurements" to share with a weight loss program, or "my active prescriptions" to share with a service that helps you find better drug prices)
  * Note that for specific use cases, these data don't need to be tamper-proof, and could be aggressively stripped down (e.g., for a drug pricing service, just the drug codes and dosage would go a long way)
* Provision access to a patient's SMART on FHIR API endpoint (e.g., "I'm going to see a specialist and by presenting a single QR, I can give them access to the FHIR API from my primary care provider's portal")

See requirements for vaccination record use case at https://hackmd.io/axTn7CqAS-Wd8MKmRApY8g

<p></p>

<hr>

_Source content from the Health Links site's User Stories page:_

<p></p>

### SHL User Stories

SMART Health Links supports multiple patterns of sharing. While the technology
is designed for flexibility and reuse in diverse contexts, the user stories
below represent flows that have explicitly informed design of the protocol.

<p></p>

#### "Powerful Portals"

Alice signs in to her state's public health portal where she can see her 
vaccination history and recommendations. She selects an option to "Share my
records with SMART Health Links", which prompts her to create a passcode
and then generates a SHL. Alice is presented with options that include:

* Copy link to clipboard.
Alice can share this SHL with others using any channel she chooses. For example,
she could paste it into a "vaccine history" form in her school's vaccine
management site as part of an online registration process. She could also share
the SHL and passcode with a friend, caregiver, or healthcare provider. The recipient 
can view data online or automatically load data into an SHL-enabled app. This
workflow can enable integration with clinician-facing EHR systems as well as
patient-facing care management apps.

* Display link as QR code.
Alice can present this QR to others. For example, she might display it to a school
nurse as part of an on-site registration process.

* Open link in a mobile health app.
Alice can open this link in her personal health app to import her historical vaccine
records. Her app will prompt her for the passcode and then will automatically 
retrieve the set of vaccine records and recommendations for display within the app. 
The app can periodically re-fetch the link to look for updates.

<p></p>

##### Additional use cases for "Powerful Portals"

* Clinical Summary from a provider portal; can share during an emergency department visit while traveling
* Lab results from a pharmacy portal

<p></p>

#### "Paper+"

Alice visits Labs-R-Us, where she has blood drawn for a basic metabolic panel.
The lab establishes a passcode (whether randomly, or based on a convention like
birth date, or by asking Alice to designate her own), then provides Alice with a
print-out including details about the test that was performed together with a 
QR code labeled as a "SMART Health Link." 

Alice can:

* Scan the SHL QR using a generic QR reader app.
This takes her to a Labs-R-Us web-based viewer where she can enter a passcode to view her lab
result. Initially she might see a "pending" result, indicating that the analysis
has not been completed. Eventually she will see a "final" result with the
details available.

* Scan the SHL QR using a SHL-aware health record management app.
Alice's health record app prompts her for a passcode and automatically retrieves the lab
results for display within the app's user interface. Initially this might be a "pending" 
result which would resolve to a "final" result after the app checks for an update at a later
date.

  * Optional follow-up step: upgrade to a long-term SMART on FHIR connection.
  If Labs-R-Us supports [SMART on FHIR for patient
  access](https://hl7.org/fhir/smart-app-launch/), Alice's health record app
  might prompt Alice to "connect to your full Labs-R-Us record." If she selects
  this option, she will be taken to the Labs-R-Us authorization screen where she
  can sign in or create an account and authorize long-term access to her full set of 
  Labs-R-Us data.

* Share the SHL with a friend, caregiver, or healthcare provider.
As in the "Powerful Portals" user story above, Alice can copy/paste the SHL to
share this lab result with a recipient of her choice. The passcode will be shared separately. 
The recipient can open the link in a web browser or in an SHL-aware health record management 
app, just as Alice can. This workflow can enable integration with clinician-facing EHR
systems as well as patient-facing care management apps.

<p></p>

##### Additional use cases for "Paper+"

* Vaccine results after a pharmacy visit
* Vision prescription after an optometrist visit
* Encounter summary after a hospital visit
* Coverage details embedded on an insurance card

<p></p>

#### "Personal Platforms" 

Alice uses a personal health record app on her phone. She connects to data from
various sources including clinical providers, labs, pharmacies, and others. When
she wants to share a subset of these data, she selects an option to "Share my
records with SMART Health Links", which prompts her to create a passcode and
then generates a SHL. Using this technique, Alice can mix and match data from
multiple sources to share a relevant subset of her records that might not exist
within any one source. Alice taps a "share" button and is prompted to copy the
link to her clipboard or display the link as a QR.

Alice can proceed to share this link as in ["Powerful Portals"](#powerful-portals).

<p></p>
<p></p>