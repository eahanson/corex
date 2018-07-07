defmodule CorexWeb.AuthGuards do
  defguard is_admin?(role) when role == :admin
  defguard is_member?(role) when role == :admin or role == :member
end
