require 'validates_email_format_of/rspec_matcher'

RSpec.describe User, type: :model do
  it { should_not be_valid }

  it {
    should validate_email_format_of(:email).with_message(I18n.t('activemodel.errors.messages.invalid_email_address'))
  }
  it 'is invalid when only name is set' do
    subject.name = 'Buddy Tester'

    should_not be_valid
    should have(:no).errors_on(:name)
    should have_at_least(1).error_on(:email)
  end

  it 'is invalid when only email is set' do
    subject.email = 'some@email.com'

    should_not be_valid
    should have(:no).errors_on(:email)
    should have_at_least(1).error_on(:name)
  end

  it 'is invalid when password is not set' do
    subject.attributes = { name: 'Buddy Tester',
                           email: 'buddy@example.com' }

    should_not be_valid
    should have(:no).errors_on(:name)
    should have(:no).errors_on(:email)
  end

  it 'is invalid when no password confirmation is set' do
    subject.attributes = { name: 'Buddy Tester',
                           email: 'buddy@example.com',
                           password: 'somepass',
                           password_confirmation: '' }

    should_not be_valid
    should have_at_least(1).error_on(:password_confirmation)
  end

  it "is invalid when passwords don't match" do
    subject.attributes = { name: 'Buddy Tester',
                           email: 'buddy@example.com',
                           password: 'somepass',
                           password_confirmation: 'wrongpass' }

    should_not be_valid
    should have_at_least(1).error_on(:password_confirmation)
  end

  it 'is invalid when using a non-unique email address' do
    subject.attributes = { name: 'Buddy Tester',
                           email: 'buddy@example.com',
                           password: 'somepass',
                           password_confirmation: 'somepass' }
    subject.save

    should_not have(:any).errors
    should be_persisted

    new_user = User.new(subject.attributes)
    new_user.save

    expect(new_user).not_to be_valid
    expect(new_user).to have_at_least(1).error_on(:email)
    expect(new_user).not_to be_persisted
  end

  it 'is valid when all properties are correct' do
    subject.attributes = { name: 'Buddy Tester',
                           email: 'buddy@example.com',
                           password: 'somepass',
                           password_confirmation: 'somepass' }

    should be_valid

    expect { subject.save }.to change { User.count }.by(1)
  end
end
