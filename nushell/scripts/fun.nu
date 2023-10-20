export def "str squarepants" [] {
  $in
    | split chars
    | enumerate
    | each { |$it|
        if $it.index mod 2 == 0 {
          $it.item | str downcase
        } else {
          $it.item | str upcase
        }
      }
    | str join
}
