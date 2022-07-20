defmodule Advisor.Person do
  use Ecto.Schema
  import Ecto.Changeset

  schema "people" do
    field(:name, :string)

    field(:profile_image, :string,
      default: "https://maxcdn.icons8.com/Share/icon/p1em/Users/user1600.png"
    )

    field(:is_mentor, :boolean, default: false)
    field(:email, :string)

    field(:password, :string, virtual: true, redact: true)
    field(:hashed_password, :string, redact: true)
    field(:confirmed_at, :naive_datetime)

    timestamps()
  end

  defimpl Bamboo.Formatter, for: Advisor.Person do
    def format_email_address(person, _opts) do
      {person.name, person.email}
    end
  end

  def changeset(person, attrs, opts \\ []) do
    cast(person, attrs, [:email, :name, :profile_image, :is_mentor, :password])
    |> validate_required([:email, :name])
    |> validate_length(:name, min: 5)
    |> validate_format(:email, ~r/@/)
    |> maybe_hash_password(opts)
    |> unique_constraint(:email)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end
end
