import type { Category, Question } from "../types/interview";

export const demoCategories: Category[] = [
  { id: 4, name: "Cong nghe thong tin", slug: "it", description: "Software developer, DevOps, QA, BA", iconUrl: null, questionCount: 128 },
  { id: 3, name: "Marketing", slug: "marketing", description: "Digital marketing, brand, performance", iconUrl: null, questionCount: 56 },
  { id: 6, name: "Kinh doanh", slug: "sales", description: "Sales, business development", iconUrl: null, questionCount: 38 },
  { id: 8, name: "Tai chinh", slug: "finance", description: "Ke toan, kiem toan, tai chinh", iconUrl: null, questionCount: 42 },
  { id: 5, name: "Nhan su", slug: "hr", description: "Tuyen dung, C&B, HR generalist", iconUrl: null, questionCount: 32 },
  { id: 7, name: "Thiet ke", slug: "design", description: "UI/UX, graphic design", iconUrl: null, questionCount: 28 },
  { id: 2, name: "Content", slug: "content", description: "Content writer, copywriter, SEO content", iconUrl: null, questionCount: 18 },
];

export const demoQuestions: Question[] = [
  {
    id: 1,
    categoryId: 4,
    categoryName: "Cong nghe thong tin",
    title: "Explain the difference between REST and GraphQL.",
    answer:
      "REST uses resource-based endpoints and standard HTTP methods. GraphQL exposes a query language where clients request the exact data shape they need. REST is simpler and cache-friendly, while GraphQL is flexible for complex client screens.",
    difficulty: "INTERMEDIATE",
    viewCount: 42,
  },
  {
    id: 2,
    categoryId: 4,
    categoryName: "Cong nghe thong tin",
    title: "What is the difference between let, const, and var in JavaScript?",
    answer:
      "var is function-scoped and can be redeclared. let and const are block-scoped. let supports reassignment, while const prevents reassignment of the binding.",
    difficulty: "BASIC",
    viewCount: 27,
  },
  {
    id: 3,
    categoryId: 3,
    categoryName: "Marketing",
    title: "How do you measure the success of a marketing campaign?",
    answer:
      "Start from the campaign objective, then track relevant metrics such as conversion rate, CAC, ROAS, qualified leads, brand lift, retention, and revenue contribution.",
    difficulty: "INTERMEDIATE",
    viewCount: 18,
  },
  {
    id: 4,
    categoryId: 6,
    categoryName: "Kinh doanh",
    title: "How would you handle a situation where a client is not satisfied?",
    answer:
      "Listen carefully, clarify the core issue, acknowledge the impact, propose concrete next steps, and follow up with a measurable resolution plan.",
    difficulty: "INTERMEDIATE",
    viewCount: 21,
  },
  {
    id: 5,
    categoryId: 8,
    categoryName: "Tai chinh",
    title: "What are the key components of a cash flow statement?",
    answer:
      "A cash flow statement includes operating cash flow, investing cash flow, and financing cash flow. It helps evaluate liquidity and the quality of earnings.",
    difficulty: "BASIC",
    viewCount: 12,
  },
  {
    id: 6,
    categoryId: 5,
    categoryName: "Nhan su",
    title: "Describe your experience in end-to-end recruitment.",
    answer:
      "A strong answer should cover intake meetings, sourcing, screening, interviewing, stakeholder feedback, offer management, onboarding, and hiring metrics.",
    difficulty: "INTERMEDIATE",
    viewCount: 36,
  },
  {
    id: 7,
    categoryId: 7,
    categoryName: "Thiet ke",
    title: "What is the difference between UX and UI design?",
    answer:
      "UX focuses on user goals, flows, information architecture, and usability. UI focuses on the visual and interactive layer users directly see and touch.",
    difficulty: "BASIC",
    viewCount: 19,
  },
  {
    id: 8,
    categoryId: 2,
    categoryName: "Content",
    title: "How do you come up with content ideas consistently?",
    answer:
      "Use customer questions, keyword research, competitor gaps, sales objections, analytics, content pillars, and recurring editorial planning rituals.",
    difficulty: "INTERMEDIATE",
    viewCount: 16,
  },
];
