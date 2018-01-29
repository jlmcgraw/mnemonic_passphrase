A utility to generate an easily rememberable passphrase using a random word as a mnemonic for it

The idea here is to make it easier to create and remember a strong passphrase.

There are options to add complexity to the passphrase (capital letters, numbers, special characters)
but since I'm not a cryptographic expert I'm not sure of the best way to do this to balance security with rememberability.  I'm open to suggestions

# Installation:

### Linux
        ./setup.sh to install Carton and update local libraries
        
### Windows
        - Get and install Strawberry perl (http://strawberryperl.com/)
        - run setup.bat to install Carton and update local libraries

# Usage:

    # Choose a random word to use as the mnemonic, default length is 5
    ./mnemonic_passwords.pl
        Random mnemonic word of length 5 is "eject"
        Random passphrase is "establish justify emptiness cyclic turbine"
        
    # Specify the length of the random mnemonic word and be verbose
    ./mnemonic_passwords.pl --length 9 -v
        Not adding drop-down because it has non-alphanumeric characters in it
        Not adding felt-tip because it has non-alphanumeric characters in it
        Not adding t-shirt because it has non-alphanumeric characters in it
        Not adding yo-yo because it has non-alphanumeric characters in it
        Word list file: eff_large_wordlist.txt
        Word count: 7772
        Requested mnemonic length: 9
        ---------
        Random mnemonic word of length 9 is "renewable"
        Random passphrase is "robe emblaze never entity waffle anemia brewing librarian ether"
        It has 143 bits of entropy and 13898717.36 quintillion possible combinations of words and symbols
        (For comparison, xkcd passphrase "correct battery horse staple" would have 99 bits of entropy)
        At 1.00 billion attempts per second it would take 4407.25 centuries to brute force

    # Supply your own mnemonic word
    ./mnemonic_passwords.pl --mnemonic google
        User supplied mnemonic is "google"
        guide of over glass level every

    # Supply your own mnemonic word and capitalize
    ./mnemonic_passwords.pl --mnemonic google --capitalize
        User supplied mnemonic is "google"
        Capitalizing l->L
        Passphrase is "gaLLon outfieLd overreach gentLeman Life expLoit"

    # Use a different word list, one word per line
    # The default list is "eff_large_wordlist.txt"
    # basic_word_list_850.txt is Ogdens basic English word list
    # The EFF word lists come from 
    # https://www.eff.org/deeplinks/2016/07/new-wordlists-random-passphrases
    #
    ./mnemonic_passwords.pl --wordlist japanese.txt 
        Random mnemonic word of length 5 is "くやくしょ"
        くちこみ ややこしい くるま しゃっきん ょ
