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

    # Choose a random word to use as the mnemonic, default length is 5 graphemes
    ./mnemonic_passwords.pl
        Random mnemonic word of length 5 is "drool"
        Random passphrase is "domestic recess overhear overture legal"

    # Specify the length of the random mnemonic word and be verbose
    ./mnemonic_passwords.pl --length 9 -v
        Word list file: eff_large_wordlist.txt
        Word count: 7772
        Requested mnemonic length: 9
        ---------
        Random mnemonic word of length 9 is "refutable"
        It has 109292263.08 quintillion possible combinations of words using this word list
        Random passphrase is "ripeness elves founder unblock tarmac aerosol backspace latticed exfoliate"
        It has 74 characters and 164 bits of entropy (for comparison, xkcd passphrase "correct battery horse staple" would have 99 bits of entropy)
        At 1.00 billion attempts per second it would take 34656.35 centuries to brute force
    
    # Add captital letters, numbers and special characters if required
    ./mnemonic_passwords.pl -s 1 -n 1 -c 1
        Random mnemonic word of length 5 is "truce"
        Including 1 capital letter(s)
        Including 1 number(s)
        Including 1 special character(s)
        Random passphrase is "tumble repeater undaunted T1{ corncob effects"


    # Supply your own mnemonic word
    ./mnemonic_passwords.pl --mnemonic thisisfun
        User supplied mnemonic is "thisisfun"
        Random passphrase is "tannery huntsman idealize stooge imperial scorpion factor undertake nullify"

    # Use a different word list, one word per line
    # The default list is "eff_large_wordlist.txt"
    # basic_word_list_850.txt is Ogdens basic English word list
    # The EFF word lists come from 
    # https://www.eff.org/deeplinks/2016/07/new-wordlists-random-passphrases
    #
    ./mnemonic_passwords.pl --wordlist japanese.txt
        Random mnemonic word of length 5 is "そとがわ"
        Random passphrase is "そつう とっきゅう かほご ゙ わかす"
