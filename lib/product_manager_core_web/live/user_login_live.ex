defmodule ProductManagerCoreWeb.UserLoginLive do
  use ProductManagerCoreWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <%!-- <.header class="text-center">
        Log in to account
        <:subtitle>
          Don't have an account?
          <.link navigate={~p"/register"} class="font-semibold text-brand hover:underline">
            Sign up
          </.link>
          for an account now.
        </:subtitle>
      </.header> --%>

      <.header class="text-center  dark:text-gray-200">
        Iniciar sesion
      </.header>

      <div class="p-5 flex justify-center py-8">
        <img class="h-12 w-auto" src={~p"/images/logo.svg"} />
      </div>
      <.simple_form for={@form} id="login_form" action={~p"/login"} phx-update="ignore">
        <.input field={@form[:email]} type="email" label="Correo electronico" required />
        <.input field={@form[:password]} type="password" label="Contraseña" required />

        <:actions>
          <.input field={@form[:remember_me]} type="checkbox" label="Recordarme" />
          <.link href={~p"/reset_password"} class="text-sm font-semibold ">
            ¿Olvidaste tu contraseña?
          </.link>
        </:actions>
        <:actions>
          <.button phx-disable-with="Signing in..." class="w-full">
            Entrar<span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>

      <%!-- <.simple_form for={@form} id="login_form" action={~p"/login"} phx-update="ignore">
        <.input field={@form[:email]} type="email" label="Email" required />
        <.input field={@form[:password]} type="password" label="Password" required />

        <:actions>
          <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
          <.link href={~p"/reset_password"} class="text-sm font-semibold">
            Forgot your password?
          </.link>
        </:actions>
        <:actions>
          <.button phx-disable-with="Logging in..." class="w-full">
            Log in <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form> --%>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
