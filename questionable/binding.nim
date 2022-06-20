import std/options
import std/macros
import ./private/binderror

proc option[T](option: Option[T]): Option[T] =
  option

proc placeholder(T: type): T =
  discard

template bindLet(name, expression): bool =
  let evaluated = expression
  let option = evaluated.option
  type T = typeof(option.unsafeGet())
  let name {.used.} = if option.isSome:
    option.unsafeGet()
  else:
    bindFailed(evaluated)
    placeholder(T)
  option.isSome

template bindVar(name, expression): bool =
  let evaluated = expression
  let option = evaluated.option
  type T = typeof(option.unsafeGet())
  var name {.used.} = if option.isSome:
    option.unsafeGet()
  else:
    bindFailed(evaluated)
    placeholder(T)
  option.isSome

macro `=?`*(name, expression): bool =
  ## The `=?` operator lets you bind the value inside an Option or Result to a
  ## new variable. It can be used inside of a conditional expression, for
  ## instance in an `if` statement.

  name.expectKind({nnkIdent, nnkVarTy})
  if name.kind == nnkIdent:
    quote do: bindLet(`name`, `expression`)
  else:
    let name = name[0]
    quote do: bindVar(`name`, `expression`)
