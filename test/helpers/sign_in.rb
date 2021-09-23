# frozen_string_literal: true

module SignIn
  def sign_in_as_with_github(name)
    user = users(name)

    OmniAuth.config.add_mock(
      :github,
      {
        uid: 12_345,
        info: { email: user[:email] }
      }
    )

    get callback_auth_url(:github)
    user
  end
end
