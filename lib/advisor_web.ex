defmodule AdvisorWeb do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use AdvisorWeb, :controller
      use AdvisorWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: AdvisorWeb
      import Plug.Conn
      alias AdvisorWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/advisor_web/templates",
        namespace: AdvisorWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, view_module: 1, view_template: 1, get_flash: 1, get_flash: 2]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      alias AdvisorWeb.Router.Helpers, as: Routes
      import AdvisorWeb.ErrorHelpers

      # Include shared imports and aliases for views
      unquote(view_helpers())

      @endpoint AdvisorWeb.Endpoint
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView and .heex helpers (live_render, live_patch, <.form>, etc)
      import Phoenix.LiveView.Helpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import AdvisorWeb.ErrorHelpers
      alias AdvisorWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
