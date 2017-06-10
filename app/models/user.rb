class User < ApplicationRecord
  has_secure_password

  validates :name,
            presence: true,
            length: {
              maximum: 128
            }
  validates :email,
            presence: true,
            uniqueness: {
              case_sensitive: false
            },
            email_format: {
              message: I18n.t('activemodel.errors.messages.invalid_email_address')
            }
  validates :password,
            presence: true,
            length: {
              minimum: 6
            },
            confirmation: true,
            if: :changing_password?

  before_save :downcase_email!

  def password=(value)
    @password_changed = true
    super value
  end

  private

  def changing_password?
    @password_changed || false
  end

  def downcase_email!
    email.downcase!
  end
end
