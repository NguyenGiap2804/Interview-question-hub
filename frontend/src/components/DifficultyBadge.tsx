import type { Difficulty } from "../types/interview";

const labels: Record<Difficulty, string> = {
  BASIC: "Basic",
  INTERMEDIATE: "Intermediate",
  ADVANCED: "Advanced",
};

export function DifficultyBadge({ difficulty }: { difficulty: Difficulty }) {
  return <span className={`difficulty difficulty-${difficulty.toLowerCase()}`}>{labels[difficulty]}</span>;
}
