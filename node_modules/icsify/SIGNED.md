##### Signed by https://keybase.io/max
```
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)
Comment: GPGTools - https://gpgtools.org

iQEcBAABCgAGBQJUUVm8AAoJEJgKPw0B/gTfj7wH/25PDZKH/XBINB4IkYEJiih3
nzQhFZQyWNXe+HJJuVfRymCZY6f7aW9L5fHEER3v/oTDF0dTouZrYpBeWrbV2CTs
AD0gmmDVC1hpFsKDujQ9pvNzth3+C5uGdafKoyjI3DhnbErAbjGMM2nB5GN8N9Jl
Otd81aUGhPS29o9Y6y6quD77YD6ppD8Wq3Cop4oALdFWiCMAXGtjjV5vIbnmlc7P
vnfcQLPzs1KbRXXgg/Okn8ChyhX6T69oiqWlttT+sqjb+uZozh+LJUUv/j7xcm6d
hE57XcD9+cB4cuklULzFgOs8gxtQUyWDe0vlIPevbVWrR8JPtA4FQqKT5m1DX0s=
=6sCh
-----END PGP SIGNATURE-----

```

<!-- END SIGNATURES -->

### Begin signed statement 

#### Expect

```
size  exec  file                        contents                                                        
            ./                                                                                          
98            .gitignore                0a915b07c06236570f7c06211cf4464ff336df6b832bf48251ffc42d2f4d8ab0
44            .travis.yml               2303095d00b06eae42c100a926e77a42c4c3664dfbc22160a4c2fd559636cf8c
1073          LICENSE                   435a6722c786b0a56fbe7387028f1d9d3f3a2d0fb615bb8fee118727c3f59b7b
              example/                                                                                  
123             baj.iced                a09b79180571a6cc6dbd7a5b61d31959cd29a81f952e0262ac92de08e33c7787
44              bar.js                  a7a013f234d6be5299c413d4ba79bdc8c624219d0984830dccb2e925c3dc3ca3
47              bat.js                  2a00aedbcb4f7c4ea15a85209aaf5a01f0b42a3c0578ffb542e3f3598a4b2cfb
32              baz.coffee              c1118275c7e15299f22f314d87410a5166b24e22838ac4b9a2fa1873bf2a533d
70              baz.litcoffee           899879f2fa7e94f56c371c232c5e6ab2d6d7539c35e160c2034c832adeb0de71
138             error.coffee            dae5202a60f7425169a7c9217a44d7b9eed734e63d9e98f1651b617dbf37c644
32              foo.coffee              6f908b4504ebd7b9cc54c9ae7646825742d6645db2fb7e5fab30a81811df7950
32              foo.iced                6f908b4504ebd7b9cc54c9ae7646825742d6645db2fb7e5fab30a81811df7950
51              foo.litcoffee           4cf40d7ca00c8b0eae03f8480a0998b4eaaea4b6191067c0559f0b5e277a3a0c
25              foo2.iced               d4330062e6563211bad11f1404077a04f22159aab7a2392af4f23b1408dd2ef9
176             multiline_error.coffee  1367b9ae39b983f94b40d3d2ccfc07f3b15c712ae3b3d5efdbb694cad69f2138
2533          index.js                  303671b6717ed7fb7f71bd691e8c4246db11c0e8ee1503c827cdfd1afa393f89
1133          package.json              5c00115f452153dee6a05d7bf15ef804e08ef9709dc8646b17c4ddc1d6d8bb2f
1061          readme.markdown           1fd8e1dbc271e1cb6519857763255c2c398f14fecd97e0265ba70e7577905a46
              test/                                                                                     
725             bundle.js               707e9a9c5e3858488c070080b49c2d32ba4f8b0ed1e8910c21ed7a3ccc2249db
1080            error.js                dfedda83a2200affd633a3b64deb377c58f51bc62db0284a8a5fafc50be9f32e
1020            transform.js            2522b7cc644fd3203e4e174f7cf768ac3ac94c3eb897eac83ea0307c3400fad2
```

#### Ignore

```
/SIGNED.md
```

#### Presets

```
git      # ignore .git and anything as described by .gitignore files
dropbox  # ignore .dropbox-cache and other Dropbox-related files    
kb       # ignore anything as described by .kbignore files          
```

<!-- summarize version = 0.0.9 -->

### End signed statement

<hr>

#### Notes

With keybase you can sign any directory's contents, whether it's a git repo,
source code distribution, or a personal documents folder. It aims to replace the drudgery of:

  1. comparing a zipped file to a detached statement
  2. downloading a public key
  3. confirming it is in fact the author's by reviewing public statements they've made, using it

All in one simple command:

```bash
keybase dir verify
```

There are lots of options, including assertions for automating your checks.

For more info, check out https://keybase.io/docs/command_line/code_signing