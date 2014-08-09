class AccountsRepository
  def initialize(collection)
    @accounts = collection
  end

  def email_taken?(email)
    @accounts.find_one(email: email) == nil
  end

  def create_account(email, encrypted_password, confirmation_token)
    @accounts.insert(
      email: email,
      password: encrypted_password,
      confirmation_token: confirmation_token,
      confirmed_at: nil,
      created_at: Time.now,
      last_signed_in_at: nil
    )
  end
end
