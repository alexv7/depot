class User < ActiveRecord::Base
  after_destroy :ensure_an_admin_remains
  validates :name, presence: true, uniqueness: true
  validates :password, presence: true
  has_secure_password

  private

    def ensure_an_admin_remains
      if User.count.zero?
        raise "Can't delete last user"
      end
    end

end


# This exception serves two purposes. First, because it is
# raised inside a transaction, it causes an automatic rollback. By raising the
# exception if the users table is empty after the deletion, we undo the delete and
# restore that last user.
# Second, the exception signals the error back to the controller, where we use
# a begin/end block to handle it and report the error to the user in the flash. If
# you want only to abort the transaction but not otherwise signal an exception,
# raise an ActiveRecord::Rollback exception instead, because this is the only exception
# that won’t be passed on by ActiveRecord::Base.transaction.
