echo "creating authinfo.plist to pre-populate username..."
cat <<'EOM' > /private/tmp/authinfo.plist
<plist>
	<dict>
		<key>Username</key>
		<string>YOUR_LOCAL_COMPUTER_USERNAME_HERE</string>
	</dict>
</plist>
EOM

echo "pre-populating authinfo.plist with current logged in username..."
sed -i '' -e "s/YOUR_LOCAL_COMPUTER_USERNAME_HERE/$USER/" /private/tmp/authinfo.plist


echo "creating personal recovery key escrowing script .command file to be executed later..."
cat <<'EOM' > /private/tmp/changeandescrowrecoverykey.command
#!/bin/sh

echo "$(tput bold)This action will attempt to escrow the Personal Recovery Key to the Jamf Server...$(tput sgr0)"

say "To complete the escrowing action you will twice, be prompted to enter your local computer account password in the Terminal Window below."
echo ""

echo "$(tput bold)$(tput setaf 1)You will be asked to enter the $(tput setaf 4)password $(tput setaf 1)for your $(tput setaf 0)$USER $(tput setaf 1)computer account...$(tput setaf 0)$(tput sgr0)"
echo "$(tput bold)$(tput setaf 2)Afterwards, you will asked to re-enter the $(tput setaf 4)password $(tput setaf 2)one more time...$(tput setaf 0)$(tput sgr0)"
echo ""
echo "Be aware that this action will only succeed if the computer account $(tput bold)$USER$(tput sgr0) is a valid SecureToken credential..."
echo "Note: Password character entry will not be visible when typed. This is normal..."

sudo fdesetup changerecovery -personal -inputplist < /private/tmp/authinfo.plist
echo ""
echo "This action has completed."
echo ""
echo "$(tput bold)$(tput setaf 1)As an additional safeguard, you may also want to transcribe a copy of the above personal recovery key onto a secure offline or remote location.$(tput sgr0)"
echo ""
echo "You may close this window."
say "This action has completed. You may close this window."
exit

EOM

echo "setting 775 permissions on changeandescrowrecoverykey.command file..."
chmod 775 "/private/tmp/changeandescrowrecoverykey.command"

open /private/tmp/changeandescrowrecoverykey.command

exit
