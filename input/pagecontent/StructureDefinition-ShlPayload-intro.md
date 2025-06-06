### Extensibility on SHL payload JSON
The SMART Health Links payload specification enables extensions to its content according to the following: 
* The specification reserves the name, `extension`, and will never define an element with that name.
* In addition, property names beginning with an underscore ("_") are reserved for extensions defined by downstream implementation guides or specific implementations.
* Extension property names SHOULD be kept short due to payload size constraints, especially when SMART Health Links are represented as QR codes.
* SMART Health Link Receiving Applications SHALL ignore extension properties they do not understand.

<p></p>

### Payload examples
- [SMART Health Links Payload object containing all properties](Binary-shl-payload-1.html)
- [Minimal SMART Health Links Payload object](Binary-shl-payload-2.html)

<p></p>
<p></p>

