# Configure SAML auth

Remember to fill out your environment URL and the Monitor or Secure API token at `../env.sh`. Depending on which API token you choose, the script will configure the settings for one or the other product.

## Examples

Show command help

```
./saml_config.sh --help
```

Get current SAML configuration

```
./saml_config.sh
```

Set some OKTA settings

```
./saml_config.sh --set --idp okta --meta 'https://foo.oktapreview.com/app/bar/sso/saml/metadata'
```

Disable user autocreation after login succeeds at IDP

```
./saml_config.sh --set --nocreate --idp okta --meta 'https://foo.oktapreview.com/app/bar/sso/saml/metadata'
```

Delete current settings:

```
./saml_config.sh --delete
```
