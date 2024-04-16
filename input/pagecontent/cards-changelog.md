_Note: This page contains content from the existing [spec.smarthealth.cards](spec.smarthealth.cards) site. It may be moved, changed or removed from the balloted FHIR IG._

<p></p>

<hr>

_From the top of the Health Cards specification's main page_

### Status

Stable release authored with input from technology, lab, pharmacy, Electronic Health Record, and Immunization Information System vendors. The current version of the framework is $CURRENT_VERSION; see the revision history below.

<p></p>

### Contributing

This specification is copyright by *Computational Health Informatics Program, Boston Children's Hospital, Boston, MA* and licensed under [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/).

We welcome discussion on the [SMART Health Cards channel](https://chat.fhir.org/#narrow/stream/284830-smart.2Fhealth-cards) of the FHIR community chat. 

_**[remove or reference HL7 jira?]**_  You can also propose changes via GitHub [Issues](https://github.com/smart-on-fhir/health-cards/issues) or create a [Pull Request](https://github.com/smart-on-fhir/health-cards/pulls).

_**[remove or ?]**_ Security issues can be disclosed privately by emailing `security@smarthealth.cards` to allow for a responsible disclosure to affected parties.

<p></p>

<hr>

_From the Health Cards specification page, Health Cards as QR Codes section:_


#### Chunking Larger SHCs (deprecated)
   
**Deprecation note: As of December 2022, support for chunking has not been widely adopted in production SHC deployments. For SHCs that need to be presented as QRs, we recommend limiting payload size to fit in a single QR (when possible), or else considering [SMART Health Links](links-index.html).**

Commonly, Health Cards will fit in a single V22 QR code. Any JWS longer than 1195 characters SHALL be split into "chunks" of length 1191 or smaller; each chunk SHALL be encoded as a separate QR code of V22 or lower, to ensure ease of scanning. Each chunk SHALL be numerically encoded and prefixed with an ordinal as well as the total number of chunks required to re-assemble the JWS, as described below. The [QR code FAQ page](cards-faq-qr.html) details max JWS length restrictions at various error correction levels.

To ensure the best user experience when producing and consuming multiple QR codes:

* Producers of QR codes SHOULD balance the sizes of chunks. For example, if a JWS is 1200 characters long, producers should create two ~600 character chunks rather than a 1191 character chunk and a 9 character chunk.
* Consumers of QR codes SHOULD allow for scanning the multiple QR codes in any order. Once the full set is scanned, the JWS can be assembled and validated.

<p></p>

<hr>

_From the Health Cards change log page, Health Cards as QR Codes section:_


### Changelog

#### 1.4.0

Deprecate "additional" top-level types like `#covid19`, `#laboratory`, and `#immunization` in favor of classifying cards based on their contents.

#### 1.3.0

* Deprecate "QR chunking" protocol, which has not seen wide adoption in real products and does not support a clean UX for presentation
* Ensure that SHCs can be used for patient summary documents
  * any FHIR `Bundle.type` is allowed
* Update introduction to reflect current status

#### 1.2.3

Clarify that payload size restrictions apply when SHCs are intended for presentation as QRs

#### 1.2.2

Update examples to include 3-dose COVID vaccination histories

#### 1.2.1

Documented optional `exp` claim for expiration

#### 1.2.0

Specified Health Card revocation

#### 1.1.1

Added verifier guidance to ignore unrecognized VC types

#### 1.1.0

Updated TLS requirements for issuer key set

#### 1.0.2

Updated links to the HL7 Implementation Guide

#### 1.0.1

Clarify FHIR API behavior when `$health-cards-issue` doesn't return results

#### 1.0.0

No functional change from 1.0.0-rc; added documentation links and re-worked introduction.

#### 1.0.0-rc

No change from 0.4.5; applying tag for connectathon release

#### 0.4.5

Clarify mapping into VC Data Model, and strip "fixed" fields from payload

#### 0.4.4

Resource.meta is allowed in one special case

#### 0.4.3

Document CORS expectation for `.well-known/jwks.json`

#### 0.4.2

Replace `iat` with `nbf` in JWT payload encoding

#### 0.4.1

Added optional `x5c` in JWKS

#### 0.3.1

Add optional `vcIndex` param on `$health-cards-issue` response's `resourceLink`

#### 0.3.0

Rename `$HealthWallet.issueVc` to `$health-cards-issue`

#### 0.2.0

Chunk-based QR representation of larger Health Cards (JWS > 1195 characters). Defines `shc:/<n>/<c>/` prefix, where `<n>` represents a chunk number and `<c>` represents the total chunk count.

#### 0.1.1

Added `shc:/` prefix for QR representations.

#### 0.1.0

Significant API overhaul to reduce scope and simplify dependencies. See [PR#64](https://github.com/smart-on-fhir/health-cards/pull/64) for details.

* Remove user DIDs from the picture. They were already optional, and in some of our most important flows unlikely to be available.

* Remove the need to bind an issuer to a holder ahead of time. SMART on FHIR clients can now call $HealthWallet.issueVc without having to call $HealthWallet.connect first

* Update $HealthWallet.issueVc response to use `valueString` (avoids the need for base64 encoding in the FHIR Parameters resource)

* Replace DID-based key discovery with hosted JSON Web Key. Establish the requirement that Issuers host `.well-known/jwks.json`

* Define requirements for keeping Health Cards' JWS representation small (small enough to fit in a QR code) -- including size limits and a method for splitting a Health Card into a Health Card Set when the size limit cannot be met

* Document process for embedding Health Cards in QR codes

* Update file extension and MIME type for representing Health Cards as downloadable files (`.smart-health-card` and `application/smart-health-card`)

* Remove SIOP flow For Verifier::Holder communications


#### 0.0.12

Add optional `resourceLink` response parameter on `$HealthWallet.issueVc`

#### 0.0.11

Change canonical domain to https://smarthealth.cards (from https://healthwallet.cards)


#### 0.0.10

Add detail on how to recognize encryption keys, signing keys, and linked domains in a DID Document

#### 0.0.9

Add discovery params to `.well-known/smart-configuration`, allowing SMART on FHIR servers to advertise Health Cards capabilities


#### 0.0.8

* Clarify that `.fhir-backed-vc` files can contain JWS- or JWE-based VCs
* Update JWS signature algorithm to `ES256`

#### 0.0.7

Simplify demographics recommendations with one uniform "minimum set"

#### 0.0.6

Updated encryption to use `"alg": "ECDH-ES"` (with `"enc": "A256GCM"`)


#### 0.0.5

Updated encryption to use `"enc": "A256GCM"`


#### 0.0.4

* Added links to overview / intro video
* Updated SIOP request to identify requested credentials by type URL (`https://healthwallet.cards#covid19` instead of `health-wallet-covid19-card`)


#### 0.0.3

* Update `.well-known` DID links and file URL to match latest spec

#### 0.0.2

* Use `valueUri` (which exists in DSTU2+) for FHIR datatypes rather than `valueUrl` (which was introduced after DSTU2)
* Added `encryptForKeyId` parameter to `$HealthWallet.issueVc` operation, defaulting to absent == no encryption
* Updated example VC JWT representations to ensure that the `.vc.credentialSubject` contains all subject-specific claims
* Defined `OperationOutcome` payload for failed `$HealthWallet.issueVc` operations
