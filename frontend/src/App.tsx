import { useEffect, useMemo, useState } from "react";
import type { CSSProperties } from "react";
import {
  ArrowUpRight,
  Bookmark,
  BookmarkCheck,
  BookOpen,
  ChevronDown,
  ChevronLeft,
  ChevronRight,
  Clock3,
  Code2,
  DollarSign,
  Edit3,
  Eye,
  Grid2X2,
  History,
  Megaphone,
  MoreVertical,
  PenLine,
  Search,
  SlidersHorizontal,
  ThumbsDown,
  ThumbsUp,
  Users,
} from "lucide-react";
import { getCategories, getQuestions } from "./api/interviewApi";
import { DifficultyBadge } from "./components/DifficultyBadge";
import type { Category, Difficulty, Question } from "./types/interview";

const difficultyOptions: Array<Difficulty | "ALL"> = ["ALL", "BASIC", "INTERMEDIATE", "ADVANCED"];

const difficultyLabels: Record<Difficulty | "ALL", string> = {
  ALL: "Difficulty",
  BASIC: "Basic",
  INTERMEDIATE: "Intermediate",
  ADVANCED: "Advanced",
};

const categoryMeta = [
  { key: "all", label: "All Categories", count: 342, icon: Grid2X2, color: "#0f7f7a" },
  { key: "it", label: "IT / Software", count: 128, icon: Code2, color: "#0f7f7a" },
  { key: "marketing", label: "Marketing", count: 56, icon: Megaphone, color: "#f97316" },
  { key: "sales", label: "Sales / Business Dev", count: 38, icon: ArrowUpRight, color: "#16a34a" },
  { key: "finance", label: "Finance / Accounting", count: 42, icon: DollarSign, color: "#16821d" },
  { key: "hr", label: "Human Resources", count: 32, icon: Users, color: "#0f75d8" },
  { key: "design", label: "Design / UI UX", count: 28, icon: PenLine, color: "#8b5cf6" },
  { key: "content", label: "Content / Writing", count: 18, icon: Edit3, color: "#ea580c" },
];

const categoryAliases: Record<string, string> = {
  "Cong nghe thong tin": "IT / Software",
  "Công nghệ thông tin": "IT / Software",
  "Truyen Thong": "Marketing",
  "Truyền thông / PR": "Marketing",
  "Kinh doanh": "Sales / Business Dev",
  "Kinh doanh / Phát triển kinh doanh": "Sales / Business Dev",
  "Tai chinh": "Finance / Accounting",
  "Tài chính / Kế toán": "Finance / Accounting",
  "Nhan su": "Human Resources",
  "Nhân sự": "Human Resources",
  "Thiet ke": "Design / UI UX",
  "Thiết kế / UI UX": "Design / UI UX",
  Content: "Content / Writing",
  "Nội dung / Viết lách": "Content / Writing",
  Marketing: "Marketing",
};

const topicAliases: Record<number, string> = {
  1: "API Design",
  2: "JavaScript",
  3: "Performance",
  4: "Client Management",
  5: "Financial Statements",
  6: "Recruitment",
  7: "Design Principles",
  8: "Content Strategy",
  9: "Design Principles",
  10: "Financial Statements",
  11: "Media Strategy",
  12: "System Debugging",
};

const fallbackAnswer = [
  "REST (Representational State Transfer) and GraphQL are both architectural styles for building APIs, but they differ in approach, flexibility, and how data is requested and returned.",
  "REST uses standard HTTP methods and resource endpoints. Each endpoint returns a fixed structure, which is simple to cache, test, and reason about.",
  "GraphQL uses a single endpoint where clients specify exactly what fields they need. This can reduce over-fetching, but requires schema discipline and careful performance controls.",
  "In interviews, a strong answer should compare tradeoffs: REST is predictable and widely adopted, while GraphQL is powerful for complex clients that need flexible data shapes.",
];

function normalizeCategoryName(name: string) {
  return categoryAliases[name] ?? name;
}

function getCategoryIcon(name: string) {
  const normalized = normalizeCategoryName(name);
  return categoryMeta.find((category) => category.label === normalized) ?? categoryMeta[0];
}

function getQuestionTopic(question: Question) {
  return question.tags?.[0] ?? topicAliases[question.id] ?? "Interview Basics";
}

export function App() {
  const [categories, setCategories] = useState<Category[]>([]);
  const [questions, setQuestions] = useState<Question[]>([]);
  const [selectedCategoryId, setSelectedCategoryId] = useState<number | null>(null);
  const [difficulty, setDifficulty] = useState<Difficulty | "ALL">("ALL");
  const [keyword, setKeyword] = useState("");
  const [selectedQuestionId, setSelectedQuestionId] = useState<number | null>(null);
  const [bookmarks, setBookmarks] = useState<Set<number>>(() => new Set([1]));
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let cancelled = false;

    async function loadCategories() {
      const result = await getCategories();
      if (!cancelled) {
        setCategories(result);
      }
    }

    void loadCategories();

    return () => {
      cancelled = true;
    };
  }, []);

  useEffect(() => {
    let cancelled = false;
    setLoading(true);

    async function loadQuestions() {
      const result = await getQuestions({ categoryId: selectedCategoryId, difficulty, keyword });
      if (!cancelled) {
        setQuestions(result);
        setSelectedQuestionId((currentId) => {
          if (result.length === 0) {
            return null;
          }
          return result.some((question) => question.id === currentId) ? currentId : result[0].id;
        });
        setLoading(false);
      }
    }

    void loadQuestions();

    return () => {
      cancelled = true;
    };
  }, [selectedCategoryId, difficulty, keyword]);

  const selectedQuestion = questions.find((question) => question.id === selectedQuestionId) ?? questions[0] ?? null;

  const visibleCategoryRows = useMemo(() => {
    const backendRows = categories.map((category) => ({
      id: category.id,
      label: category.name,
      count: category.questionCount,
      icon: getCategoryIcon(category.name).icon,
      color: getCategoryIcon(category.name).color,
    }));

    return backendRows.length > 0
      ? backendRows
      : categoryMeta.slice(1).map((category, index) => ({
          id: index + 1,
          label: category.label,
          count: category.count,
          icon: category.icon,
          color: category.color,
        }));
  }, [categories]);

  const categoryTotal =
    categories.length > 0
      ? categories.reduce((total, category) => total + category.questionCount, 0)
      : categoryMeta[0].count;

  function toggleBookmark(questionId: number) {
    setBookmarks((current) => {
      const next = new Set(current);
      if (next.has(questionId)) {
        next.delete(questionId);
      } else {
        next.add(questionId);
      }
      return next;
    });
  }

  return (
    <div className="app-shell">
      <header className="topbar">
        <div className="brand">
          <div className="brand-mark">
            <BookOpen size={22} />
          </div>
          <h1>Interview Question Hub</h1>
        </div>

        <label className="global-search">
          <Search size={19} />
          <input
            value={keyword}
            onChange={(event) => setKeyword(event.target.value)}
            placeholder="Search questions"
            type="search"
          />
          <kbd>⌘K</kbd>
        </label>

        <div className="profile-actions" aria-label="Profile actions">
          <button type="button" aria-label="Bookmarks">
            <Bookmark size={20} />
          </button>
          <button type="button" aria-label="Recently viewed">
            <Clock3 size={20} />
          </button>
          <div className="divider" />
          <div className="avatar">TU</div>
          <div className="profile-copy">
            <strong>Tuan Nguyen</strong>
            <span>Candidate</span>
          </div>
          <ChevronDown size={18} />
        </div>
      </header>

      <main className="workspace">
        <aside className="sidebar" aria-label="Categories">
          <div className="section-heading">
            <span>Categories</span>
            <button className="icon-button active" type="button" aria-label="Category grid">
              <Grid2X2 size={18} />
            </button>
          </div>

          <button className={`category-row ${selectedCategoryId === null ? "active" : ""}`} type="button" onClick={() => setSelectedCategoryId(null)}>
            <span className="category-icon" style={{ "--accent": categoryMeta[0].color } as CSSProperties}>
              <Grid2X2 size={20} />
            </span>
            <strong>All Categories</strong>
            <span className="category-count">{categoryTotal}</span>
          </button>

          <div className="category-list">
            {visibleCategoryRows.map((category) => {
              const Icon = category.icon;
              return (
                <button
                  className={`category-row ${selectedCategoryId === category.id ? "active" : ""}`}
                  type="button"
                  key={`${category.label}-${category.id}`}
                  onClick={() => setSelectedCategoryId(category.id)}
                >
                  <span className="category-icon" style={{ "--accent": category.color } as CSSProperties}>
                    <Icon size={21} />
                  </span>
                  <strong>{category.label}</strong>
                  <span className="category-count">{category.count}</span>
                </button>
              );
            })}
          </div>

          <section className="quick-stats">
            <h2>Quick Stats</h2>
            <dl>
              <div>
                <dt>
                  <BookOpen size={15} />
                  Total Questions
                </dt>
                <dd>{categoryTotal}</dd>
              </div>
              <div>
                <dt>
                  <Bookmark size={15} />
                  Bookmarked
                </dt>
                <dd>{bookmarks.size + 10}</dd>
              </div>
              <div>
                <dt>
                  <History size={15} />
                  Recently Viewed
                </dt>
                <dd>24</dd>
              </div>
              <div>
                <dt>
                  <Clock3 size={15} />
                  Practice Sessions
                </dt>
                <dd>8</dd>
              </div>
            </dl>
          </section>
        </aside>

        <section className="question-column" aria-label="Question list">
          <div className="toolbar">
            <label className="search-box">
              <Search size={19} />
              <input value={keyword} onChange={(event) => setKeyword(event.target.value)} placeholder="Search questions" type="search" />
            </label>

            <div className="select-like" aria-label="Difficulty">
              <select value={difficulty} onChange={(event) => setDifficulty(event.target.value as Difficulty | "ALL")}>
                {difficultyOptions.map((option) => (
                  <option value={option} key={option}>
                    {difficultyLabels[option]}
                  </option>
                ))}
              </select>
              <ChevronDown size={17} />
            </div>

            <button className="sort-button" type="button">
              <SlidersHorizontal size={17} />
              Newest
              <ChevronDown size={17} />
            </button>
          </div>

          <p className="result-count">{selectedCategoryId ? questions.length : categoryTotal} questions found</p>

          <div className="question-list">
            {loading ? (
              <div className="empty-state">Loading questions</div>
            ) : questions.length === 0 ? (
              <div className="empty-state">No question matches the current filters.</div>
            ) : (
              questions.map((question) => {
                const meta = getCategoryIcon(question.categoryName);
                const Icon = meta.icon;
                return (
                  <article className={`question-card ${selectedQuestion?.id === question.id ? "active" : ""}`} key={question.id}>
                    <button className="question-main" type="button" onClick={() => setSelectedQuestionId(question.id)}>
                      <span className="question-icon" style={{ "--accent": meta.color } as CSSProperties}>
                        <Icon size={22} />
                      </span>
                      <span className="question-copy">
                        <strong>{question.title}</strong>
                        <span>
                          {normalizeCategoryName(question.categoryName)}
                          <i />
                          {getQuestionTopic(question)}
                        </span>
                      </span>
                    </button>

                    <DifficultyBadge difficulty={question.difficulty} />
                    <button
                      className={`bookmark-button ${bookmarks.has(question.id) ? "saved" : ""}`}
                      type="button"
                      aria-label={bookmarks.has(question.id) ? "Remove bookmark" : "Save bookmark"}
                      onClick={() => toggleBookmark(question.id)}
                    >
                      {bookmarks.has(question.id) ? <BookmarkCheck size={20} /> : <Bookmark size={20} />}
                    </button>
                  </article>
                );
              })
            )}
          </div>

          <footer className="pagination" aria-label="Pagination">
            <button type="button" aria-label="Previous page">
              <ChevronLeft size={18} />
            </button>
            <button className="current" type="button">
              1
            </button>
            <button type="button">2</button>
            <button type="button">3</button>
            <button type="button">4</button>
            <button type="button">5</button>
            <span>...</span>
            <button type="button">18</button>
            <button type="button" aria-label="Next page">
              <ChevronRight size={18} />
            </button>
            <button className="page-size" type="button">
              20 / page
              <ChevronDown size={16} />
            </button>
          </footer>
        </section>

        <aside className="detail-panel" aria-label="Answer guide">
          {selectedQuestion ? (
            <>
              <div className="detail-actions">
                <span>Answer guide</span>
                <div>
                  <button className="icon-button active" type="button" onClick={() => toggleBookmark(selectedQuestion.id)} aria-label="Save current question">
                    {bookmarks.has(selectedQuestion.id) ? <BookmarkCheck size={19} /> : <Bookmark size={19} />}
                  </button>
                  <button className="icon-button" type="button" aria-label="More actions">
                    <MoreVertical size={19} />
                  </button>
                </div>
              </div>

              <h2>{selectedQuestion.title}</h2>
              <div className="detail-meta">
                <span>{normalizeCategoryName(selectedQuestion.categoryName)}</span>
                <i />
                <span>{getQuestionTopic(selectedQuestion)}</span>
                <DifficultyBadge difficulty={selectedQuestion.difficulty} />
              </div>

              <nav className="answer-tabs" aria-label="Answer tabs">
                <button className="active" type="button">
                  Answer
                </button>
                <button type="button">Related Questions (8)</button>
              </nav>

              <article className="answer-block">
                {(selectedQuestion.id === 1 ? fallbackAnswer : [selectedQuestion.answer]).map((paragraph, index) => (
                  <p key={paragraph}>
                    {index === 1 && <strong>1. Core Concept</strong>}
                    {index === 2 && <strong>2. Data Fetching</strong>}
                    {index === 3 && <strong>3. Versioning</strong>}
                    {paragraph}
                  </p>
                ))}
              </article>

              <footer className="detail-footer">
                <span>
                  <Eye size={16} />
                  {selectedQuestion.viewCount + 100} views
                </span>
                <span>Updated 2 days ago</span>
                <div>
                  <button type="button" aria-label="Helpful">
                    <ThumbsUp size={19} />
                  </button>
                  <button type="button" aria-label="Not helpful">
                    <ThumbsDown size={19} />
                  </button>
                </div>
              </footer>
            </>
          ) : (
            <div className="empty-state">Select a question to view the answer guide.</div>
          )}
        </aside>
      </main>
    </div>
  );
}
