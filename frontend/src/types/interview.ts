export type Difficulty = "BASIC" | "INTERMEDIATE" | "ADVANCED";

export interface Category {
  id: number;
  name: string;
  slug: string;
  description: string;
  iconUrl: string | null;
  questionCount: number;
}

export interface Question {
  id: number;
  categoryId: number;
  categoryName: string;
  title: string;
  answer: string;
  difficulty: Difficulty;
  viewCount: number;
  tags?: string[];
}
