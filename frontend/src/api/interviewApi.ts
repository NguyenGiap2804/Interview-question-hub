import { demoCategories, demoQuestions } from "../data/demoData";
import type { Category, Difficulty, Question } from "../types/interview";

const API_BASE = import.meta.env.VITE_API_BASE_URL ?? "";

async function getJson<T>(path: string): Promise<T> {
  const response = await fetch(`${API_BASE}${path}`);

  if (!response.ok) {
    throw new Error(`Request failed: ${response.status}`);
  }

  return response.json() as Promise<T>;
}

export async function getCategories(): Promise<Category[]> {
  try {
    const categories = await getJson<Category[]>("/api/categories");
    if (categories.some((category) => category.slug === "truyen-thong")) {
      return demoCategories;
    }
    return categories;
  } catch {
    return demoCategories;
  }
}

export async function getQuestions(params: {
  categoryId?: number | null;
  difficulty?: Difficulty | "ALL";
  keyword?: string;
}): Promise<Question[]> {
  const query = new URLSearchParams();

  if (params.categoryId) {
    query.set("categoryId", String(params.categoryId));
  }

  if (params.difficulty && params.difficulty !== "ALL") {
    query.set("difficulty", params.difficulty);
  }

  if (params.keyword?.trim()) {
    query.set("keyword", params.keyword.trim());
  }

  const path = query.size > 0 ? `/api/questions?${query.toString()}` : "/api/questions";

  try {
    const questions = await getJson<Question[]>(path);
    if (questions.some((question) => question.title.includes("OOP la gi"))) {
      return filterDemoQuestions(params);
    }
    return questions;
  } catch {
    return filterDemoQuestions(params);
  }
}

function filterDemoQuestions(params: {
  categoryId?: number | null;
  difficulty?: Difficulty | "ALL";
  keyword?: string;
}): Question[] {
  const keyword = params.keyword?.trim().toLowerCase() ?? "";

  return demoQuestions.filter((question) => {
    const matchesCategory = !params.categoryId || question.categoryId === params.categoryId;
    const matchesDifficulty = !params.difficulty || params.difficulty === "ALL" || question.difficulty === params.difficulty;
    const matchesKeyword =
      keyword.length === 0 ||
      question.title.toLowerCase().includes(keyword) ||
      question.answer.toLowerCase().includes(keyword);

    return matchesCategory && matchesDifficulty && matchesKeyword;
  });
}
