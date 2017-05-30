

## How to implement ICS with ES6 Yield

Can either rely on yield native or [Traceur](https://github.com/google/traceur-compiler) or
[Regenerator](https://facebook.github.io/regenerator/) on ES5 implementations.

### Strategy

Input CS:

```coffeescript

foo = (x, cb) ->
  for i in [0...x]
    await
      console.log "wait #{i}"
      setTimeout defer(), i*10
  cb()
```

Output JS:

```javascript

function foo (x, cb) { var __iced_passed_deferral = iced.findDeferrals(arguments); var __it = (function* () {
	for (var i = 0; i < x; i++) {
		(function(it) { var __iced_deferrals = new Deferrals(it, { parent : __iced_passed_deferral });
			console.log("wait " + i);
	    	setTimeout(__iced_deferrals.defer(), i*10); __iced_deferalls.fulfill(); })(__it); yield; }
	cb()
}

```


