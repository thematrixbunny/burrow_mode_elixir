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
