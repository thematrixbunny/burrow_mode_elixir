# BurrowMode 🟢 — foco, concentração e distrações (estilo Matrix)  

Pequena lib em **Elixir** para avaliar foco (0..10) vs distrações (0..10), calcular um **score**, retornar **status** e **recomendações**.  
Inclui “**overflow**” temático: se `focus > 10`, você entra em **PURE CODE** — *“You are pure code”*.  

---

## Sumário
- [Sobre](#sobre)
- [Pré-requisitos](#pré-requisitos)
- [Instalação](#instalação)
- [Uso rápido](#uso-rápido)
- [API](#api)
- [Exemplos](#exemplos)
- [Validações e Overflows](#validações-e-overflows)
- [Testes](#testes)
- [Roteiro / Ideias futuras](#roteiro--ideias-futuras)
- [Licença](#licença)

---

## Sobre
O **BurrowMode** modela um “estado mental” de estudo/trabalho usando:
- `focus` (0..10): intensidade de foco
- `distraction` (0..10): ruído/interruptores
- `score = focus - distraction`
- **Status** descritivo e **recomendações** práticas
- **Overflows**:
  - `focus > 10` → “🟢 You are pure code...”
  - `distraction > 10` → “⚠️ Distração além dos limites humanos — reinicie seu sistema.”

---

## Pré-requisitos
- Elixir **1.13+**
- Erlang/OTP **24+**

> Funciona em versões anteriores, mas recomenda-se OTP 24+ (melhorias de JIT/VM).

---

## Instalação

Crie um projeto novo (opcional):

```bash
mix new burrow_mode
cd burrow_mode
```

Adicione o módulo abaixo em `lib/burrow_mode.ex`:

```elixir
defmodule BurrowMode do
  @moduledoc """
  Simula o estado de foco vs distração em estilo Matrix.
  Escala normal: 0..10, mas se ultrapassar 10, você vira código puro.
  """

  def run(focus, distraction) when focus < 0 or distraction < 0 do
    "❌ Valores inválidos. Use apenas 0 a 10."
  end

  def run(focus, distraction) do
    cond do
      focus > 10 ->
        "🟢 You are pure code..."

      distraction > 10 ->
        "⚠️ Distração além dos limites humanos — reinicie seu sistema."

      true ->
        score = focus - distraction
        %{
          focus: focus,
          distraction: distraction,
          score: score,
          status: status_message(score),
          advice: recommendation(score)
        }
    end
  end

  defp status_message(score) do
    cond do
      score >= 8 -> "🔥 Burrow Mode Máximo — imersão total!"
      score >= 5 -> "🦾 Concentração alta — distrações mínimas."
      score >= 2 -> "⚖️ Concentração moderada — pode melhorar."
      score > 0 -> "⚠️ Baixa concentração — ambiente pouco favorável."
      score == 0 -> "🔄 Equilibrado, mas instável — atenção!"
      score < 0 -> "🚨 Distrações dominando — hora de agir!"
    end
  end

  defp recommendation(score) do
    cond do
      score >= 8 -> "Mantenha o ambiente e rotina como estão."
      score >= 5 -> "Evite novas distrações e mantenha pausas controladas."
      score >= 2 -> "Elimine fontes de distração visíveis."
      score > 0 -> "Faça uma pausa estratégica e recomece."
      score == 0 -> "Defina prioridades e feche notificações."
      score < 0 -> "Desconecte-se do que não é essencial e reorganize."
    end
  end
end

# Exemplos:
IO.inspect BurrowMode.run(12, 2) # You are pure code
IO.inspect BurrowMode.run(9, 1)  # Alta concentração
IO.inspect BurrowMode.run(4, 9)  # Distrações dominando
IO.inspect BurrowMode.run(0, 0)  # Equilibrado, mas instável
IO.inspect BurrowMode.run(-1, 5) # Valores inválidos
IO.inspect BurrowMode.run(5, 5)  # Equilibrado demais
```

---

## Uso rápido

Abra o IEx dentro do projeto:

```bash
iex -S mix
```

Chame o módulo:

```elixir
BurrowMode.run(9, 1)
BurrowMode.run(12, 2)
BurrowMode.run(4, 9)
BurrowMode.run(0, 0)
BurrowMode.run(-1, 5)
BurrowMode.run(5, 5)
```

---

## API

### `BurrowMode.run(focus, distraction) :: map | String.t()`
- **Parâmetros**:
  - `focus` *(inteiro)*: 0..10 (aceita >10 para overflow)
  - `distraction` *(inteiro)*: 0..10 (aceita >10 para overflow)
- **Retorno**:
  - **Mapa** com `:focus`, `:distraction`, `:score`, `:status`, `:advice` quando dentro do intervalo normal.
  - **String** temática quando ocorre overflow ou valores inválidos.

**Score**
- `score = focus - distraction`

**Faixas de status**
- `>= 8` → “🔥 Burrow Mode Máximo…”
- `>= 5` → “🦾 Concentração alta…”
- `>= 2` → “⚖️ Concentração moderada…”
- `> 0` → “⚠️ Baixa concentração…”
- `== 0` → “🔄 Equilibrado…”
- `< 0` → “🚨 Distrações dominando…”

---

## Validações e Overflows

- Valores **negativos** → `"❌ Valores inválidos. Use apenas 0 a 10."`
- `focus > 10` → `"🟢 You are pure code..."`
- `distraction > 10` → `"⚠️ Distração além dos limites humanos — reinicie seu sistema."`

---

## Testes

Crie `test/burrow_mode_test.exs`:

```elixir
defmodule BurrowModeTest do
  use ExUnit.Case, async: true
  doctest BurrowMode

  test "score e mensagens normais" do
    r = BurrowMode.run(9, 1)
    assert r.score == 8
    assert r.status =~ "Burrow Mode Máximo"
  end

  test "overflow focus > 10" do
    assert BurrowMode.run(11, 0) =~ "You are pure code"
  end

  test "overflow distraction > 10" do
    assert BurrowMode.run(6, 11) =~ "Distração além dos limites humanos"
  end

  test "valores inválidos" do
    assert BurrowMode.run(-1, 5) =~ "Valores inválidos"
  end
end
```

Rode os testes:

```bash
mix test
```

---

## Roteiro / Ideias futuras
- CLI (`mix burrow`): `mix burrow --focus 7 --distraction 2`
- “Chuva de código” (Matrix) no terminal quando `focus > 10`
- Exportar sessões em JSON/CSV para acompanhar evolução
- Modo “dicas personalizadas” com base no histórico
- Livebook/Notebook para visualização de progresso

---

## Licença
MIT — sinta-se livre para usar, modificar e compartilhar. 💚
