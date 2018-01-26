A utility to generate an easily rememberable passphrase using a random word as a mnemonic

# Installation:

### Windows
        - Get and install Strawberry perl (http://strawberryperl.com/)
        - run setup.bat to install Carton and update local libraries

### Linux
        ./setup.sh to install Carton and update local libraries

# Usage:

    # Choose a random word to use as the mnemonic, default length is 5
    ./mnemonic_passwords.pl
        Random mnemonic word of length 5 is "crush"
        cover regret use sponge hollow
    
    # Specify the length of the random mnemonic word
    ./mnemonic_passwords.pl --length 12
        Random mnemonic word of length 12 is "organization"
        owner range gold answer nose if zoo account thought impulse owner not

    # Supply your own mnemonic word
    ./mnemonic_passwords.pl --mnemonic google
        User supplied mnemonic is "google"
        guide of over glass level every

    # Supply your own mnemonic word and capitalize
    ./mnemonic_passwords.pl --mnemonic google --capitalize
        User supplied mnemonic is "google"
        Get Over Office Group Level Exchange

    # Use a different word list, one word per line
    # The default list is "eff_large_wordlist.txt"
    # basic_word_list_850.txt is Ogdens basic English word list
    # The EFF word lists come from 
    # https://www.eff.org/deeplinks/2016/07/new-wordlists-random-passphrases
    #
    ./mnemonic_passwords.pl --wordlist japanese.txt 
        Random mnemonic word of length 5 is "くやくしょ"
        くちこみ ややこしい くるま しゃっきん ょ
