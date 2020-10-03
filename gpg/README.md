
## Import a public key:
Import a public key to the gpg program like this. See: https://www.gnupg.org/gph/en/manual/x56.html.

    gpg --import some_public_key.GPG

## Verify a gpg-signed file which was signed with the private key pair to the public key you just imported above:
Then, verify a signed file against its accompanying singature file, like this (assuming it was signed with the matching private key pair for the public key you just imported above). See: https://gnupg.org/download/integrity_check.html.

    gpg --verify gnupg-2.2.21.tar.bz2.sig gnupg-2.2.21.tar.bz2



