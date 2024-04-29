
### Actors

* Software Applications
  * **SMART Health Links Sharing Application**. Helps users creates, manage, and share SMART Health Links. Also referred to below as "server". This application can include local software as well as server-side components.
  * **SMART Health Links Receiving Application**. Helps users receive SMART Health Links and work with associated content. Also referred to below as "client".
* Users
  * **Sharing User**. An individual working with a SMART Health Links Sharing Application to create/manage/share information
  * **Receiving User**. An individual working with a SMART Health Links Receiving Application to retrieve/display/use information. In autonomous use cases there may be no Receiving User.

<p></p>

### Pre-protocol step: Sharing User configures a new SMART Health Links

Working with a SMART Health Links Sharing Application, the Sharing User makes a few decisions up front:

* **What to share**. Depending on the SMART Health Links Sharing Application, the Sharing User might explicitly choose a set of files or define a "sharing policy" that matches different data over time.
* **Whether the SMART Health Links will require a Passcode** to access. Depending on the SMART Health Links Sharing Application, a Passcode may be mandatory.
* **Whether the SMART Health Links will expire** at some pre-specified time. Depending on the SMART Health Links Sharing Application, an expiration time may be mandatory.

Regarding "what to share": a single SMART Health Links at a specific point in time will *resolve* to a manifest of files of the following types:
* `application/smart-health-card`: a JSON file with a `.verifiableCredential` array containing SMART Health Card JWS strings, as specified by https://spec.smarthealth.cards#via-file-download.
* `application/fhir+json`: a JSON file containing any FHIR resource (e.g., an individual resource or a Bundle of resources). Note that this format is not inherently tamper-proof, but the content may be include digital signatures or have other verification processes associated with it, which are not defined here.
* `application/smart-api-access`: a JSON file with a SMART Access Token Response (see [SMART App Launch](https://hl7.org/fhir/smart-app-launch/app-launch.html#response-5)). Two additional properties are defined:
  * `aud` Required string indicating the FHIR Server Base URL where this token can be used (e.g.,  ``"https://server.example.org/fhir"``)
  * `query`: Optional array of strings acting as hints to the client, indicating queries it might want to make (e.g., `["Coverage?patient=123&_tag=family-insurance"]`)

At configuration time, the SMART Health Links Sharing Application SHALL generate a random key used for encrypting/decrypting the files in the manifest (see ["Decryption"](#encrypting-and-decrypting-files)). 

<p></p>

**Design Note: Trust and encryption**

*This pattern of encrypting files allows for deployment scenarios where the file server is not trusted to know the information inside the manifest's files. In such scenarios, the Sharing User and Receiving User can consider the server  a blind intermediary. That said: in many deployment scenarios, the file server will be hosted by a healthcare provider or other entity that already has access to such files. For consistency, this protocol always applies encryption.*

<p></p>

**Design Note: SMART Health Links Sharing Application "internals"**

*We do not standardize the protocol by which the SMART Health Links Sharing Application's local software communicates with its server-side components. These may be provided by the same vendor and use internal APIs to communicate -- or there may be no "local" software at all.*

<p></p>

### SMART Health Links Sharing Application Generates a SMART Health Links URI

#### Establish a SMART Health Links Manifest URL

Based the configuration from (1), the SMART Health Links Sharing Application generates a "manifest URL" for the new SMART Health Links. The manifest URL:

* SHALL include at least **256 bits of entropy**
    * A suggested approach is to generate a cryptographically strong 32-byte random sequence and then base64url-encode this sequence to obtain a 43-character string that is used as a path segment. For example: `https://shl.example.org/manifests/I91rhba3VsuGXGchcnr6VHlQFKxfE28kuZ0ssbEuxno/manifest.json`
* SHALL NOT exceed **128 characters** in length (note, this maximum applies to the `url` field of the SMART Health Links Payload, not to the entire SMART Health Links URI).

The SMART Health Links Sharing Application incorporates the manifest URL into a SMART Health Links as described below.

<p></p>

#### Construct a SMART Health Links Payload

The SMART Health Links Payload is a JSON object including the following properties:

* `url`: Manifest URL for this SMART Health Links
* `key`: Decryption key for processing files returned in the manifest. 43 characters, consisting of 32 random bytes base64urlencoded.
* `exp`: Optional. Number representing expiration time in Epoch seconds, as a hint to help the SMART Health Links Receiving Application determine if this QR is stale. (Note: epoch times should be parsed into 64-bit numeric types.)
* `flag`: Optional. String created by concatenating single-character flags in alphabetical order
  * `L` Indicates the SMART Health Links is intended for long-term use and manifest content can evolve over time 
  * `P` Indicates the SMART Health Links requires a Passcode to resolve
  * `U` Indicates the SMART Health Links's `url` resolves to a single encrypted file accessible via `GET`, bypassing the manifest. SHALL NOT be used in combination with `P`.
* `label`: Optional.  String no longer than 80 characters that provides a short description of the data behind the SMART Health Links. 
* `v`: Optional. Integer representing the SMART Health Links protocol version this SMART Health Links conforms to. MAY be omitted when the default value (`1`) applies.

The JSON Payload is then:
* Minified
* Base64urlencoded
* Prefixed with `shlink:/`
* Optionally prefixed with a viewer URL that ends with `#`

<p></p>

**Design Note: Protocol Versioning**

Implementations can rely on the following behaviors:

* SMART Health Links Payload processing for `shlink:` URIs
  * SMART Health Links Payloads SHALL be constructed as per `"v":1` (i.e., payloads are Base64urlencoded, minified JSON objects)
    * Any changes to this design will require a new URI scheme, rather than a `v` bump
* SMART Health Links Payload stability
  * `.label`, `.exp`, and `.flag` SHALL always work as defined for `"v":1`
    * Any changes to this design will require a new URI scheme, rather than a `v` bump
  * New properties MAY be introduced without a version bump, as long as they're optional and safe to ignore
  * SMART Health Links Receiving Application SHALL ignore properties they don't recognize
  * Introduction of properties that can't safely be ignored will require a `v` bump
* SMART Health Links Payload flags
  * New flag values MAY be introduced without a version bump, as long as they're safe to ignore. For example, the v1 flag `L` is safe to ignore because the client will still be able to handle a one-time manifest request. The `P` flag however cannot be ignored because the server will respond with an error if no passcode is provided.
  * SMART Health Links Receiver Application SHALL ignore flag values they don't recognize
  * Introduction of new flag values that can't safely be ignored will require a `v` bump
* Manifest URL request/response
  * New request parameters or headers MAY be introduced without a version bump, as long as they're optional and safe to ignore, or gated by a flag or property in the SMART Health Links Payload
  * New response parameters or headers MAY be introduced without a version bump, as long as they're optional and safe to ignore, or gated by a request parameter
  * SMART Health Links Sharing Application and SMART Health Links Receiving Application SHALL ignore parameters and headers they don't recognize
  * Introduction of parameters or headers that can't safely be ignored will require a `v` bump
* Encryption and signature schemes
  * Changes to the cryptographic protocol will require a `v` bump

This means that SMART Health Links Receiver Applications can always recognize a SMART Health Links Payload and display its label to the user. If a SMART Health Links Receiver Application receives a SMART Health Links with a `v` newer than what it supports, it SHOULD display an appropriate message to the user and SHOULD NOT proceed with a manifest request, unless it has some reason to believe that proceeding is safe.

<p></p>

**Design Note: Viewer URL Prefixes**

*By using viewer URLs that end in `#`, we take advantage of the browser behavior where `#` fragments are not sent to a server at the time of a request. Thus the SMART Health Links payload will not appear in server-side logs or be available to server-side processing when a link like `https://viewer.example.org#shlink:/ey...` is opened in a browser.*

The following optional step may occur sometime after a SMART Health Links is generated:
* **Optional: Update Shared Files**. For some sharing scenarios, Sharing User MAY update the shared files from time to time (e.g., when new lab results arrive or new immunizations are performed). Updated versions SHALL be encrypted using the same key as the initial version. 

<p></p>

#### Example SMART Health Links Generation
```js
import { encode as b64urlencode } from 'https://deno.land/std@0.82.0/encoding/base64url.ts';

const shlinkJsonPayload = {
  "url": "https://ehr.example.org/qr/Y9xwkUdtmN9wwoJoN3ffJIhX2UGvCL1JnlPVNL3kDWM/m",
  "flag": "LP",
  "key": "rxTgYlOaKJPFtcEd0qcceN8wEU4p94SqAwIWQe6uX7Q",
  "label": "Back-to-school immunizations for Oliver Brown"
}

const encodedPayload = b64urlencode(JSON.stringify(shlinkJsonPayload))
// "eyJ1cmwiOiJodHRwczovL2Voci5leGFtcGxlLm9yZy9xci9ZOXh3a1VkdG1OOXd3b0pvTjNmZkpJaFgyVUd2Q0wxSm5sUFZOTDNrRFdNL20iLCJmbGFnIjoiTFAiLCJrZXkiOiJyeFRnWWxPYUtKUEZ0Y0VkMHFjY2VOOHdFVTRwOTRTcUF3SVdRZTZ1WDdRIiwibGFiZWwiOiJCYWNrLXRvLXNjaG9vbCBpbW11bml6YXRpb25zIGZvciBPbGl2ZXIgQnJvd24ifQ"

const shlinkBare = `shlink:/` + encodedPayload;
// "shlink:/eyJ1cmwiOiJodHRwczovL2Voci5leGFtcGxlLm9yZy9xci9ZOXh3a1VkdG1OOXd3b0pvTjNmZkpJaFgyVUd2Q0wxSm5sUFZOTDNrRFdNL20iLCJmbGFnIjoiTFAiLCJrZXkiOiJyeFRnWWxPYUtKUEZ0Y0VkMHFjY2VOOHdFVTRwOTRTcUF3SVdRZTZ1WDdRIiwibGFiZWwiOiJCYWNrLXRvLXNjaG9vbCBpbW11bml6YXRpb25zIGZvciBPbGl2ZXIgQnJvd24ifQ"

const shlink = `https://viewer.example.org#` + shlinkBare
// "https://viewer.example.org#shlink:/eyJ1cmwiOiJodHRwczovL2Voci5leGFtcGxlLm9yZy9xci9ZOXh3a1VkdG1OOXd3b0pvTjNmZkpJaFgyVUd2Q0wxSm5sUFZOTDNrRFdNL20iLCJmbGFnIjoiTFAiLCJrZXkiOiJyeFRnWWxPYUtKUEZ0Y0VkMHFjY2VOOHdFVTRwOTRTcUF3SVdRZTZ1WDdRIiwibGFiZWwiOiJCYWNrLXRvLXNjaG9vbCBpbW11bml6YXRpb25zIGZvciBPbGl2ZXIgQnJvd24ifQ"
```

<p></p>

####  Sharing User transmits a SMART Health Links

The Sharing User can convey a SMART Health Links by any common means including e-mail, secure messaging, or other text-based communication channels. When presenting a SMART Health Links in person, the Sharing User can also display the link as a QR code using any standard library to create a QR image from the SMART Health Links URI. 

When sharing a SMART Health Links via QR code, the following recommendations apply:

* Create the QR with Error Correction Level M
* Include the [SMART Logo](https://demo.vaxx.link/smart-logo.svg) on a white background over the center of the QR, scaled to occupy 5-6% of the image area (inclusive of the "quiet zone" QR border).

<p></p>

### SMART Health Links Receiving Application processes a SMART Health Links

The SMART Health Links Receiving Application can process a SMART Health Links using the following steps.

* Decode the SMART Health Links JSON payload
* Issue a [SMART Health Links Manifest Request](#smart-health-links-manifest-request) to payload's `url`
* Decrypt and process files from the manifest
* Optional:  When the original QR includes the `L` flag for long-term use, the SMART Health Links Receiving Application can re-fetch the manifest periodically, following [polling guidance](#polling-manifest-for-changes) to avoid issing too many requests
 
<p></p>

### SMART Health Links Manifest Request

When no `U` flag is present, the SMART Health Links Receiving Application SHALL retrieve a SMART Health Links's manifest by issuing a request to the `url` with:

* Method: `POST`
* Headers:
  * `content-type: application/json`
* Body: JSON object including
  * `recipient`: Required. A string describing the recipient (e.g.,the name of an organization or person) suitable for display to the Receiving User
  * `passcode`: Conditional. SHALL be populated with a user-supplied Passcode if the `P` flag was present in the SMART Health Links payload
  * `embeddedLengthMax`: Optional. Integer upper bound on the length of embedded payloads (see [`.files.embedded`](#filesembedded-content))

If the SMART Health Links is no longer active, the Resource Server SHALL respond with a 404.

If an invalid Passcode is supplied, the Resource Server SHALL reject the request and SHALL enforce a total lifetime count of incorrect Passcodes for a given SMART Health Links, to prevent attackers from performing an exhaustive Passcode search. The error response for an invalid Passcode SHALL use the `401` HTTP status code and the response body SHALL be a JSON payload with

* `remainingAttempts`: number of attempts remaining before the SMART Health Links is disabled

<p></p>

**Design Note: Monitoring remaining attempts**
Servers need to enforce a total lifetime count of incorrect Passcodes even in the face of attacks that attempt multiple Passcodes in separate, parallel HTTP requests (i.e., with little or no delay between requests). For example, servers might employ measures to limit the number of in-flight requests for a single SMART Health Links at any given time, ensuring that requests are processed serially through the use of synchronization or shared state.

<p></p>

If the SHlink request is valid, the Resource Server SHALL return a  SMART Health Links Manifest File with `content-type: application/json`. The SMART Health Links Manifest File is a JSON object with a `files` array where each entry includes:

* `contentType`: One of  the following values:
    * `"application/smart-health-card"` or
    *  `"application/smart-api-access"` or 
    *  `"application/fhir+json"`
* `location` (SHALL be present if no `embedded` content is included): URL to the file.
This URL SHALL be short-lived and intended for single use. For example, it could be a
short-lifetime signed URL to a file hosted in a cloud storage service (see signed URL docs for [S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/ShareObjectPreSignedURL.html), [Azure](https://learn.microsoft.com/en-us/rest/api/storageservices/create-service-sas), and [GCP](https://cloud.google.com/storage/docs/access-control/signed-urls)).
* `embedded` (SHALL be present if no `location` is included): JSON string directly
embedding the encrypted contents of the file as a compact JSON Web Encryption
string (see ["Encrypting"](#encrypting-and-decrypting-files)).

<p></p>

#### Polling manifest for changes
When the original QR includes the `L` flag for long-term use, the client MAY
periodically poll for changes in the manifest. The server MAY provide a
[`Retry-After`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Retry-After)
header on successful manifest responses, indicating the minimum time that the
client SHOULD wait before its next polling request. If manifest requests are
issued too frequently, the server MAY respond with HTTP status `429 Too Many
Requests` and a `Retry-After` header indicating the minimum time that a client
SHALL wait before re-issuing a manifest request.

<p></p>

**Design Note: Rate Limiting**
*More detailed guidance on polling will require real-world implementation experience. The current guidance provides the client a hint about how often to poll, and provides a way to convey that requests are being issued too frequently. We encourage implementers to experiment with additional capabilities.*

<p></p>

####  `.files.location` links

The SMART Health Links Sharing Application SHALL ensure that `.files.location` links can be dereferenced
without additional authentication, and that they are short-lived. The lifetime
of `.files.location` links SHALL NOT exceed one hour. The SMART Health Links Sharing Application MAY create
one-time-use `.files.location` links that are consumed as soon as they are
dereferenced.

Because the manifest and associated files are a single package that may change over time, the SMART Health Links Receiving Application SHALL treat any manifest file locations as short-lived and
potentially limited to one-time use. The SMART Health Links Receiving Application SHALL NOT attempt to
dereference a manifest's `.files.location` link more than one hour after
requesting the manifest, and SHALL be capable of re-fetching the manifest to
obtain fresh `location` links in the event that they have expired or been
consumed.

The SMART Health Links Sharing Application SHALL respond to the `GET` requests for `.files.location` URLs with:

* Headers:
  * `content-type: application/jose`
* Body: JSON Web Encryption as described in <a href="#encrypting-and-decrypting-files">Encrypting and Decrypting Files</a>.

<p></p>

#### `.files.embedded` content

If the client has specified `embeddedLengthMax` in the manifest request, the sever SHALL NOT
embedded payload longer than the client-designated maximum.

If present, the `embedded` value SHALL be up-to-date as of the time the manifest is
requested. If the client has specified `embeddedLengthMax` in the manifest request,
the sever SHALL NOT embedded payload longer than the client-designated maximum.

The embedded content is a JSON Web Encryption as described in <a href="#encrypting-and-decrypting-files">Encrypting and Decrypting Files</a>.

<p></p>

#### Example SMART Health Links Manifest File

```json
{
  "files": [{
    "contentType": "application/smart-health-card",
    "location": "https://bucket.cloud.example.org/file1?sas=MFXK6jL3oL3SI_lRfi_-cEfzIs5oHs6rRWmrsCAFzvk"
  }, 
  {
    "contentType": "application/smart-health-card",
    "embedded": "eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIn0..8zH0NmUXGwMOqEya.xdGRpgyvE9vNoKzHlr4itKKW2vo<snipped>"
  },
  {
    "contentType": "application/fhir+json",
    "location": "https://bucket.cloud.example.org/file2?sas=T34xzj1XtqTYb2lzcgj59XCY4I6vLN3AwrTUIT9GuSc"
  }]
}
```
<p></p>

#### SMART Health Links Direct File Request (with `U` Flag)

When the `U` flag is present, the SMART Health Links Receiving Application SHALL NOT make a request for the manifest. Instead, the application SHALL retrieve a SMART Health Links's sole encrypted file by issuing a request to the `url` with:

* Method: `GET`
    * Query parameters
        * `recipient`: Required. A string describing the recipient (e.g.,the name of an organization or person) suitable for display to the Data Sharer

<p></p>

### Encrypting and Decrypting Files

SMART Health Links files are always symmetrically encrypted with a SMART Health Links-specific key. Encryption is performed using JSON Web Encryption (JOSE JWE) compact serialization with `"alg": "dir"`, `"enc": "A256GCM"`, and a `cty` header indicating the content type of the payload (e.g., `application/smart-health-card`, `application/fhir+json`, etc).

<p></p>

#### Example Encryption

```ts
import * as jose from 'https://deno.land/x/jose@v4.7.0/index.ts'

const exampleShcFromWeb = await fetch("https://spec.smarthealth.cards/examples/example-00-e-file.smart-health-card");
const exampleShcBody = new Uint8Array(await exampleShcFromWeb.arrayBuffer());
const exampleContentType = 'application/smart-health-card'

const shlinkPayload =  {
  "key": "rxTgYlOaKJPFtcEd0qcceN8wEU4p94SqAwIWQe6uX7Q",
  // other properties omitted; not relevant for this example
};

const encrypted = await new jose
  .CompactEncrypt(new Uint8Array(exampleShcBody))
  .setProtectedHeader({
    alg: 'dir',
    enc: 'A256GCM',
    cty: exampleContentType,
  })
  .encrypt(jose.base64url.decode(shlinkPayload.key));

console.log(encrypted)
//eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIiwiY3R5IjoiYXBwbGljYXRpb24vc21hcnQtaGVhbHRoLWNhcmQifQ..B9Bd5AW751az-gEx.iah6mxLb5TQe2ZfCwEUs4R1t8WoP0mnFc-TUzN1NIyzUeDwJNOcxv4CY8wV6ys4Dicnr3IhqTvVU1RbR-4eq1GCd4g96faV8_0MbHwXzP246Tz9BDLhQ2zlAjYqvvCi_JuWdyWqGhKeWGX1XibNHFzzVT0FmYensfKF4o0uSeZWQDKVEEhzMSKuALMpUkfwHcmCRfLT-ctANSxq-Zj0IIeT66XbztOomStjlfi-F-FaqBGZfHOARCVvT143CTYELLJCUdD4qUVkrNuLmRZrNuqVpY0g5BjABswkIoDmyoRJAEohuZCamZNA--p-uRqJjRefED1eMrKSppabV2ugaqoFlieujTOE-a3VKib9aC-lFsmLalkwh9ctr_FZqS9H46rqGjGcOxtAXalo1jkMPGupVsE1W-xIH14wbPCYcgfldH9SH7X60462kxD8OFdHpvnnfAvjQnaE4QDqasT5ySpBRtck4GVxs2IRBt62-kOlzoI8lHapLdwIms-Gdt7z38E47ZE3afE4IIbobPGz7wGvjbi3z234ARvGQ4jREgPQb1NRYAEtZlrZNzR6N7ofXD8jF502tw-QWI_Ox0jFP5tynIiMp-hG25ecQ0s4MzPHFC0ZABPamgg3MS-UILl76gMDCHS5Te_JAXZoC1HnkETw5M217SaG5ISAU0F5qETMREfTjZR9E45MDhnw7uY1vo2lffRB3ei1QqGuLh0gUnVU7TUfFYwcOqV15sb0t1lMj0mmyG5v-_dE9H6dYtRKJARltmdfSmc1HisBewx75Xh5ChJQ1hiCEDaZ1wqFjsFJ6SrKgJ7C1N7vx6QKx8YXwFH7ePG2qG39leT5JKZnqAvi9fqc6x-YwfhSjbRKGZoj2o55Fd2fbwtK6CXpiW6AekT7PUcl_7ynTq-DaQ_Yc29WwtmgapcCRNpfcMsoqCD4giu1V3Sj5DQLglwuk1gAMcuV5fo8JpABu2_is83WZ_GJ1WWMUxyZGq6u-EGuZrP96Yewb7-zfnt2lao_LJg1ef5cqDTW7-0MS27wkmLiIi0e-PYvS-UfWVHg1oNbR-MHXMVEQ6gqNg08IgEyPDSFCUbf75HuMILN80bQNtSlFj6FR7uNKHr8sigvKI80k.5flOKKmeqYm0TamwROr8Nw
```
<p></p>

#### Example Decryption

```ts
import * as jose from 'https://deno.land/x/jose@v4.7.0/index.ts'

const shlinkPayload =  {
  "key": "rxTgYlOaKJPFtcEd0qcceN8wEU4p94SqAwIWQe6uX7Q",
  // other properties omitted; not relevant for this example
};

// Output from "encrypt" example above
const fileEncrypted = "eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIiwiY3R5IjoiYXBwbGljYXRpb24vc21hcnQtaGVhbHRoLWNhcmQifQ..B9Bd5AW751az-gEx.iah6mxLb5TQe2ZfCwEUs4R1t8WoP0mnFc-TUzN1NIyzUeDwJNOcxv4CY8wV6ys4Dicnr3IhqTvVU1RbR-4eq1GCd4g96faV8_0MbHwXzP246Tz9BDLhQ2zlAjYqvvCi_JuWdyWqGhKeWGX1XibNHFzzVT0FmYensfKF4o0uSeZWQDKVEEhzMSKuALMpUkfwHcmCRfLT-ctANSxq-Zj0IIeT66XbztOomStjlfi-F-FaqBGZfHOARCVvT143CTYELLJCUdD4qUVkrNuLmRZrNuqVpY0g5BjABswkIoDmyoRJAEohuZCamZNA--p-uRqJjRefED1eMrKSppabV2ugaqoFlieujTOE-a3VKib9aC-lFsmLalkwh9ctr_FZqS9H46rqGjGcOxtAXalo1jkMPGupVsE1W-xIH14wbPCYcgfldH9SH7X60462kxD8OFdHpvnnfAvjQnaE4QDqasT5ySpBRtck4GVxs2IRBt62-kOlzoI8lHapLdwIms-Gdt7z38E47ZE3afE4IIbobPGz7wGvjbi3z234ARvGQ4jREgPQb1NRYAEtZlrZNzR6N7ofXD8jF502tw-QWI_Ox0jFP5tynIiMp-hG25ecQ0s4MzPHFC0ZABPamgg3MS-UILl76gMDCHS5Te_JAXZoC1HnkETw5M217SaG5ISAU0F5qETMREfTjZR9E45MDhnw7uY1vo2lffRB3ei1QqGuLh0gUnVU7TUfFYwcOqV15sb0t1lMj0mmyG5v-_dE9H6dYtRKJARltmdfSmc1HisBewx75Xh5ChJQ1hiCEDaZ1wqFjsFJ6SrKgJ7C1N7vx6QKx8YXwFH7ePG2qG39leT5JKZnqAvi9fqc6x-YwfhSjbRKGZoj2o55Fd2fbwtK6CXpiW6AekT7PUcl_7ynTq-DaQ_Yc29WwtmgapcCRNpfcMsoqCD4giu1V3Sj5DQLglwuk1gAMcuV5fo8JpABu2_is83WZ_GJ1WWMUxyZGq6u-EGuZrP96Yewb7-zfnt2lao_LJg1ef5cqDTW7-0MS27wkmLiIi0e-PYvS-UfWVHg1oNbR-MHXMVEQ6gqNg08IgEyPDSFCUbf75HuMILN80bQNtSlFj6FR7uNKHr8sigvKI80k.5flOKKmeqYm0TamwROr8Nw"

const decrypted = await jose.compactDecrypt(
  fileEncrypted,
  jose.base64url.decode(shlinkPayload.key)
);

console.log(decrypted.protectedHeader.cty)
//application/smart-health-card

const decoded = JSON.parse(new TextDecoder().decode(decrypted.plaintext));
/*
{
  verifiableCredential: [
    "eyJ6aXAiOiJERUYiLCJhbGciOiJFUzI1NiIsImtpZCI6IjNLZmRnLVh3UC03Z1h5eXd0VWZVQUR3QnVtRE9QS01ReC1pRUxMMTFX..."
  ]
}
*/
```
<p></p>

### Use Case Examples

#### Using SMART Health Links to share an interactive experience

While the SMART Health Links spec focuses on providing access to structured data, it's often
useful to share an interactive experience such as a web-based diagnostic portal where the
SMART Health Links Receiving Application can review and add comments to a patient record. This can be accomplished
in SMART Health Links with a manifest entry of type `application/fhir+json` that provides a
[FHIR Endpoint resource](https://hl7.org/fhir/endpoint.html) where:

* `name` describes the interactive experience with sufficient detail for the Receiving User to decide whether to engage
* `connectionType` is `{"system": "https://smarthealthit.org", "code": "shl-interactive-experience"}`
* `address` is the URI for the interactive experience
* `period` optionally documents the window of time when the interactive experience is available

For example, the manifest for an SMART Health Links that offers the user the opportunity to "Review a case"
might include a `application/fhir+json` entry with:

```json
{
  "resourceType": "Endpoint",
  "status": "active",
  "name": "Review and comment on Alice's case in ACME Medical Diagnostic Portal",
  "address": "https://interact.example.org/case-id/521039c3-4bb9-45bd-8271-6001d2f4dea9",
  "period": {"end": "2022-10-20T12:30:00Z"},
  "connectionType": {"system": "https://smarthealthit.org", "code": "shl-interactive-experience"},
  "payloadType": [{"system": "http://terminology.hl7.org/CodeSystem/endpoint-payload-type", "code": "none"}],
}
```
<p></p>

Notes:

* There is no perfect FHIR resource for documenting an interactive experience URL. `Endpoint` and `DocumentReference` are both plausible candidates, and we recommend `Endpoint` here because `DocumentReference` is designed for static payloads.
* If the *only* content being shared via SMART Health Links is a single interactive experience, implementers might consider sharing the interactive experience URL directly, instead of through SMART Health Links. However, since SMART Health Links provides a consistent pattern that users and tools can recognize, starting with SMART Health Links provides a foundation to support future expansion.

<p></p>

#### "Upgrading" from SMART Health Links to a consumer-mediated SMART on FHIR Connection

In addition to providing direct access to a pre-configured data set, SMART Health Linkss can include information
to help establish a consumer-mediated SMART on FHIR connection to the data source. This can be
accomplished with a SMART Health Links manifest entry of type `application/fhir+json` that provides a
[FHIR Endpoint resource](https://hl7.org/fhir/endpoint.html) where:

* `name` describes the SMART on FHIR endpoint with sufficient detail for the Receiving User to decide whether to connect
* `connectionType` is `{"system": "http://terminology.hl7.org/CodeSystem/restful-security-service", "code": "SMART-on-FHIR"}`
* `address` is the FHIR API base URL of the server that supports [SMART App Launch](http://hl7.org/fhir/smart-app-launch/)

For example, the manifest for an SMART Health Links from Labs-R-Us might include a `application/fhir+json` entry with:

```json
{
  "resourceType": "Endpoint",
  "status": "active",
  "name": "Labs-R-Us Application Access",
  "address": "https://fhir.example.org",
  "connectionType": {"system": "http://terminology.hl7.org/CodeSystem/restful-security-service", "code": "SMART-on-FHIR"},
  "payloadType": [{"system": "http://terminology.hl7.org/CodeSystem/endpoint-payload-type", "code": "none"}],
}
```
<p></p>

Notes:

* Clients may need to pre-register with the SMART App Launch enabled service
before they can request a connection. A client might compare `"address"`
against an internal database to determine whether it can connect, retrieve
`{address}/.well-known/smart-configuration` to determine whether the [Dynamic
Client Registration
Protocol](https://hl7.org/fhir/smart-app-launch/app-launch.html#register-app-with-ehr)
is available or come up with another way to determine connectivity in order to
inform the user of how they can act on the SMART Health Links.

* This capability will only work in cases where the user receiving the SMART Health Links is authorized
to approve SMART App Launch requests; other recipients might see the Endpoint
but would be unable to complete a SMART App Launch
