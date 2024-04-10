export def "jwt decode" [] {
  let split_jwt = ($in | split column ".")

  let header = ($split_jwt.column1 | decode base64 -c url-safe-no-padding | get 0 | from json)
  let claims = ($split_jwt.column2 | decode base64 -c url-safe-no-padding | get 0 | from json)

  { header:$header claims:$claims }
}

