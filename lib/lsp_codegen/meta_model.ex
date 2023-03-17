defmodule LSPCodegen.MetaModel do
  @moduledoc """
  The actual meta model.
  """

  alias LSPCodegen.{
    Enumeration,
    Notification,
    Request,
    Structure,
    TypeAlias
  }

  use TypedStruct

  typedstruct enforce: true do
    field :enumerations, list(Enumeration.t()), default: []
    field :notifications, list(Notification.t()), default: []
    field :requests, list(Request.t()), default: []
    field :structures, list(Structure.t()), default: []
    field :type_aliases, list(TypeAlias.t()), default: []
  end

  def new(%{enumerations: e, notifications: n, requests: r, structures: s, typeAliases: t}) do
    %__MODULE__{
      enumerations: for(enum <- e, do: Enumeration.new(enum)),
      notifications: for(noti <- n, do: Notification.new(noti)),
      requests: for(req <- r, do: Request.new(req)),
      structures: for(struct <- s, do: Structure.new(struct)),
      type_aliases: for(type <- t, do: TypeAlias.new(type))
    }
  end
end
