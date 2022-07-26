export def "str squarepants" [] {
  $in
    | split chars
    | each -n { |$it|
        if $it.index mod 2 == 0 {
          $it.item | str downcase
        } else {
          $it.item | str upcase
        }
      }
    | str collect
}
