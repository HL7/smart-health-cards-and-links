
### Looking for a non-technical overview?

See the [SMART Health Cards public landing page](https://smarthealth.cards/).

<p></p>

### Can a SMART Health Card be used as a form of identification?

No. SMART Health Cards are designed for use *alongside* existing forms of identification (e.g., a driver's license in person, or an online ID verification service). A SMART Health Card is a non-forgeable digital artifact analogous to a paper record on official letterhead. Concretely, the problem SMART Health Cards solve is one of provenance: a digitally signed SMART Health Card is a credential that guarantees that a specific issuer generated the record. The duty of verifying that the person presenting a Health Card *is* the subject of the data within the Health Card (or is authorized to act on behalf of this data subject) falls to the person or system receiving and validating a Health Card.

<p></p>

### Which clinical data should be considered in decision-making?

* The data in Health Cards should focus on communicating "immutable clinical facts".
* Each use case will define specific data profiles.
    * For COVID-19 Vaccination Credentials, the [SMART Health Cards: Vaccination and Testing FHIR IG](https://build.fhir.org/ig/HL7/fhir-shc-vaccination-ig) defines requirements.
* When Health Cards are used in decision-making, the verifier is responsible for deciding what rules to apply. For example:
    * decision-making rules may change over time as our understanding of the clinical science improves.
    * decision-making rules may be determined or influenced by international, national and local health authorities.
    * decision-making rules may require many inputs, some of which can be supplied by Health Cards and others of which may come from elsewhere (e.g., by asking the user "are you experiencing any symptoms today?").

<p></p>

### How can we share conclusions like a "Safe-to-fly Pass", instead of sharing clinical results?

Decision-making often results in a narrowly-scoped "Pass" that embodies conclusions like "Person X qualifies for international flight between Country A and Country B, according to Rule Set C". While Health Cards are designed to be long-lived and general-purpose, Passes are highly contextual. We are not attempting to standardize "Passes" in this framework, but Health Cards can provide an important verifiable input for the generation of Passes.

<p></p>

### What testing tools are available to validate SMART Health Cards implementations?

The following tools are helpful to validate Health Card artifacts:

* The [HL7 FHIR Validator](https://confluence.hl7.org/display/FHIR/Using+the+FHIR+Validator) can be used to validate the Health Card's FHIR bundle
* The [Health Cards Dev Tools](https://github.com/smart-on-fhir/health-cards-dev-tools) can be used to validate the various Health Card artifacts.

Other resources that are helpful for learning about and implementing SMART Health Cards include:

* The [code used to generate the examples](https://github.com/smart-on-fhir/health-cards/tree/main/generate-examples) present in the spec.
* A [Jupyter Notebook walkthrough](https://github.com/dvci/health-cards-walkthrough/blob/main/SMART%20Health%20Cards.ipynb) and [demo portals](https://demo-portals.smarthealth.cards/) which demonstrate creating, validating and decoding a SMART Health Card as a QR code.

<p></p>

### Where can I find earlier Requests for Comment (RFCs)?

This [RFC page](https://github.com/smart-on-fhir/health-cards/tree/main/rfcs) in the SMART Health Cards GitHub contains RFCs related to SMART Health Cards.


### What software libraries are available to work with SMART Health Cards?

The [Libraries for SMART Health Cards](https://github.com/smart-on-fhir/health-cards/wiki/Libraries-for-SMART-Health-Cards) wiki page includes suggestions about useful libraries.

<p><p>

### What are security considerations for an issuer?

**Can someone steal my keys?**

The issuer private keys must be generated, stored, and protected with great care, same as with PKI keys. The OWASP key management [cheat sheet](https://cheatsheetseries.owasp.org/cheatsheets/Key_Management_Cheat_Sheet.html) provides guidance on these items. To lower the risk of a key compromise, it is recommended to rotate issuance keys every year.

**Can someone pretend to be me?**

Health cards are digitally signed, using strong, state-of-the-art cryptographic algorithms. Health card forgery is only possible if someone
1. gains access to the issuer private key(s),
2. takes control of the issuer endpoint (encoded in the health card) and replaces the public key set with a fake one, or
3. modifies the issuer’s information in a trust framework directory.

**Can a rogue insider start issuing health cards?**

Anyone with access to the issuer private keys can issue health cards under the issuer’s identity. Make sure these are generated, stored, and protected adequately. The OWASP key management [cheat sheet](https://cheatsheetseries.owasp.org/cheatsheets/Key_Management_Cheat_Sheet.html) provide guidance on these items. To reduce the risk of insider threats, an issuer should have good audit practices, and log when a health card is issued, and by which employee.

**I found fraudulent health cards falsely issued under my name, what should I do?**

Is the key used to issue these fraudulent health cards still in your published issuer public key set? If so, you need to retire that key immediately: delete the public key in the published key set and the corresponding private key. This will also invalidate all real cards issued under that key; contact your users to help them get a new health card.

If you don't recognize the key, are they tricking verifiers into thinking you are part of the same organization? Has the rogue key been listed as trusted in a trust framework? If so, follow the framework's method to have it removed.

**I’m changing my keys, will my previously issued health cards still be valid?**

Expired private keys should be deleted, the corresponding public keys should stay in the issuer published key set to allow verifiers to validate health cards issued using them. Revoked private keys (compromised, issued in error, etc.) should be deleted and removed from the published key set.

**Some cards have been erroneously issued, can they be revoked?**

Starting from v1.2.0, individual health cards issued by mistake can be revoked by listing its revocation identifier in an issuer's revocation list. Legacy health cards can use an external mechanism to derive a revocation identifier based on the health card's content. See the [revocation FAQ](cards-faq-revocation.html) for more details.

<p></p>

### What are security considerations for the patient?

**Can someone steal my health card?**

A health card (digital file or paper QR code) is a “bearer” credential, anyone holding it can present it. Since all the contents of the health card is presented to verifiers, an attacker would need to have matching identifying information to use it illegitimately.

**What if I lose my health card?**

A health card file is a normal file, you can make back-ups. The QR code on a paper card contains all the digitally signed information to present to a verifier; presenting a backup photocopy or a picture of the QR code is enough for a verifier to validate the health card information.

**Am I disclosing too much information when presenting a health card?**

All the content of the health card is disclosed when presenting it. Issuers, wallet applications, and QR paper cards should clearly indicate what information is encoded and disclosed when presenting a health card.

<p></p>

### What are security considerations for the verifier?


**How do I recognize forged health cards?**
Health cards are digitally signed, using strong, state-of-the-art cryptographic algorithms. It is infeasible to forge a health card without compromising a trusted issuer private key, and to modify one without invalidating its signature. Never rely solely on the textual elements of a paper card or a wallet app, always verify the cryptographic signature protecting the health card.

**How can I trust the issuer of a health card?**

The specified validation steps ensure that a presented health card was properly signed by an issuer key. How to trust that key is application/organization specific. In most cases, issuers will be part of a trust framework that verifiers will choose to accept (like how merchants accept Visa, Mastercard, AMEX). Verifiers therefore need to make sure the signing key is a valid identity in the frameworks they accept. For keys that are part of a directory-based trust framework, make sure the key is part of the trusted directory. For keys that are part of a PKI-based trust framework, make sure that:
1. the JSON key matches the key in the PKI certificate,
2. the PKI certificate chain is valid (not expired at card issuance time, nor revoked),
3. the PKI certificate chain roots into a trusted identity.

<p></p>

### What is the Max JWS length for a V22 QR at various error correction levels?

A single, non-chunked Version 22 SMART Health Card QR contains two segments
* The first Byte mode segment (`shc:/`) always has 20 header bits and 40 data bits for a total of 60 bits.[<sup>1</sup>](https://www.nayuki.io/page/optimal-text-segmentation-for-qr-codes)
* The second segment (the numeric encoded QR code) always has 16 header bits and a variable number of data bits depending on the QR code length.[<sup>1</sup>](https://www.nayuki.io/page/optimal-text-segmentation-for-qr-codes)

The max JWS size that can fit in a single Version 22 QR code depends on the remaining space, which depends on the error correction used.

76 bits are already reserved for the required segment headers and `shc:/` prefix. The following table lists the total number of bits a Version 22 QR Code can contain.


| Error Correction Level | Total data bits for V22 QR |
| ------------- | ------------- |
| Low  | 8048  |
| Medium  | 6256  |
| Quartile  | 4544  |
| High  | 3536  |

[<sup>2 (Table Source)</sup>](https://www.qrcode.com/en/about/version.html)


Each JWS character is encoded into two numeric characters (As described in [Encoding Chunks as QR codes](https://spec.smarthealth.cards/#encoding-chunks-as-qr-codes))
and each numeric character requires 20/6 bits.[<sup>1</sup>](https://www.nayuki.io/page/optimal-text-segmentation-for-qr-codes)

Thus we can determine the maximum JWS size for each error correction with the following:

JWS Size
=  ((Total Data Bits - 76 bits reserved) * 6/20 bits per numeric character * 1/2 JWS character per numeric character
= (Total Data Bits - 76)*3/20

The results of the above rounded down to the nearest integer number of characters gives:

| Error Correction Level | Max JWS Length for V22 QR |
| ------------- | ------------- |
| Low  | 1195  |
| Medium  | 927  |
| Quartile  | 670  |
| High  | 519  |

**References:**
1. [Project Nayuki: Optimal text segmentation for QR Codes](https://www.nayuki.io/page/optimal-text-segmentation-for-qr-codes)
2. [QR Code capacities](https://www.qrcode.com/en/about/version.html)

<p></p>

### What are distinctions with respect to the WHO "Smart Vaccination Certificates" RC1?

On March 19th, 2021, the WHO released [Interim guidance for developing a Smart Vaccination Certificate](https://www.who.int/publications/m/item/interim-guidance-for-developing-a-smart-vaccination-certificate). Here are some key distinctions to keep in mind with respect to WHO RC1:

1. Project names

    * "**SMART**" in SMART Health Cards refers to the [SMART Health IT project](https://smarthealthit.org/about-smart-2/), and stands for "_Substitutable Medical Applications, Reusable Technologies_".
    * "**Smart**" in WHO's Smart Vaccination Certificates is unrelated to SMART Health IT or SMART on FHIR.

1. WHO RC1 has a wider scope than SMART Health Cards; WHO's scope includes continuity of care in addition to proof of vaccination.

1. WHO RC1 assumes there will be national-level infrastructure for centralizing records for a given country. SMART Health Cards is designed to operate without this sort of central infrastructure.

1. WHO RC1 does not yet define technical details for active implementation, such as the specific format for QR codes and other artifacts.

1. WHO RC1 defines a data model for what should be included in a proof of vaccination. SMART Health Cards provides a similar data model via the [SMART Health Cards: Vaccination & Testing Implementation Guide](http://vci.org/ig/vaccination-and-testing). The SMART IG aligns closely but not perfectly with WHO RC1 recommendations. Improving this alignment where possible is on the roadmap for the Vaccination & Testing Implementation Guide.

<p></p>

### What are methods for revoking SMART Health Cards?

Starting from v1.2.0 of the SMART Health Card (SHC) framework, individual health cards issued by mistake can be revoked by listing its revocation identifier in an issuer's revocation list. Legacy health cards can use an external mechanism to derive a revocation identifier based on the health card's content; see the [legacy revocation methods](#legacy-revocation-methods) section below.

#### Main revocation method

**What should I use as a revocation identifier?**

Issuers that keep track of every single issued SHC could create a per-SHC `rid` for fine-grained revocation. In many cases, an issuer will have an internal user ID that can be used to revoke all cards belonging to a particular user; using the timestamp feature allows an issue to invalidate cards up to a certain time.

**Why is a one-way transformation on the user ID recommended for revocation ID?**

Publishing an internal user ID might be a privacy issue. A one-way transform with high-entropy input prevents reversal of the CRL’s content. The proposed HMAC-SHA-256 algorithm using a 256-bit key achieves that.

**Why are Card Revocation Lists tied to a key identifier?**

Since SHC don’t have expiry dates, public keys and revocation information must be publicly available forever. Creating a per-kid CRL allows issuers to cap the size of CRLs, and verifier apps might not need to download the CRLs of old keys when the corresponding SHCs are replaced by newer ones.

**Why is there a limit on the size of the revocation ID?**

Per-design, SHC are small to fit into QR codes. Moreover, verifier applications might need to store the aggregated revocation information from many issuers; capping the `rid` size therefore limits the bandwidth and storage requirements of verifiers.

The recommended methods of taking the base64url encoding of the b4-bit truncated HMAC-SHA-256 output results in 11 characters. The 24-character limit allows the encoding of 128-bit values in base64url, if required by an issuer.

<p></p>

#### Legacy revocation methods
_**To be reviewed**_

Note: This section will contain information about the legacy methods once these are specified.

**Why are the legacy methods specified externally?**

The legacy methods must derive a revocation ID based on the SHC content. Since the revocation IDs are publicly published, it is inevitable to prevent a determined attacker with sufficient resources from guessing the correct data leading to a particular revocation ID. Since this has privacy implications, each issuer must decide on the appropriate method to use in their jurisdiction.









### Patient-Focused FAQs

**Introduction**

When enrolling for school, entering a workplace, or booking travel, you might be asked to provide information about a COVID-19 test or vaccination. With SMART Health Cards, you can keep a standardized digital or paper copy of your information and share it when you choose. Unlike most paper cards, a SMART Health Card is "verifiable": it includes a digital signature from the organization that gives you the card, which helps ensure the information is correct.

**What's a SMART Health Card?**

A SMART Health Card contains information about you:
* Your legal name and date of birth
* Your clinical information (test result or vaccination record)
  * Test results include information about when a test was performed, the test manufacturer, and if the results were positive or negative
  * Vaccination records include the type of vaccine, and the time and place of your vaccination

**Where can I get a SMART Health Card?**

Any organization that has your information might be able to issue you a SMART Health Card. That could be the lab, clinic, pharmacy, or site where you got your COVID-19 vaccine or lab test, even after you received your immunization. The place that gives you the card "signs" it digitally, which helps ensure the information is correct. Additionally, if you manage the healthcare of your child or another person, you may also access and download their SMART Health Cards.

**Is there any fee required to get or use a SMART Health Card?**

There should be no fee to get a SMART Health Card. If you decide to share the information in your SMART Health Card with somebody, there should be no fee for you or them.

**How do SMART Health Cards protect my privacy?**

You are in control of sharing, or not sharing, your SMART Health Card. If you choose, you can print your SMART Health Card on paper, or save it in an app on your phone. If you have a printed SMART Health Card, you decide when to let someone scan it. If you have a SMART Health Card on your phone, you decide when to share.

SMART Health Cards contain only your name, date of birth, and information about your COVID-19 immunization or lab results. They do not contain your phone number, address, a government-issued identifier, or any other information about your health.

Your information is stored directly within a SMART Health Card barcode ("QR Code") or a SMART Health Card file that you control. It is not stored in any computer systems outside of the organization that gave you the SMART Health Card.

**How can I use a SMART Health Card?**

You might receive a SMART Health Card printed on a piece of paper or electronically from your doctor's office. This SMART Health Card contains information about you; the card is yours, and you can share it when you choose.

On paper, your SMART Health Card contains your information, including a 2D barcode; it will look something like this:

<img src="reference_smart_health_card_pdf_vaccine.png" width="700" alt="SMART Health Card example" />

You might also have access to your SMART Health Card through a website or an app on your phone. You can choose to print these barcodes yourself or let someone scan the barcode right from your personal device.

**Sharing SMART Health Cards as barcodes**

A SMART Health Card usually includes just one barcode, but might include two barcodes or more. By allowing someone to scan these barcodes from your paper print-out or from your phone's screen, you are sharing the information in your SMART Health Card.

**Sharing SMART Health Cards app-to-app**

You might be able to share your SMART Health Card from one app on your phone to another. When you share a SMART Health Card with an app on your phone, you are sharing the information in your SMART Health Card.

**Destroying SMART Health Cards**

You can destroy a paper-based SMART Health Card or delete an electronic SMART Health Card at any time. Keep in mind that anyone you have shared this information with may still have a copy.

**What apps can I use with a SMART Health Card?**

Here are some of the apps that help you access or share your SMART Health Card:
* _TBD_



<p></p>
<p></p>