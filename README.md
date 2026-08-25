# catering

Проект кейтеринга: автоматизация подготовки чек-листов мероприятий по клиентским брифам.

## Какой skill выбрать

| Задача | Skill |
|--------|--------|
| Только саммари брифа и сверка с вкладкой, **без правок** чек-листа | **Check** — `.cursor/skills/check/SKILL.md` |
| Заполнить / поправить чек-лист по брифу | **Lucy** — `.cursor/skills/lucy/SKILL.md` |

## Skill: Check

Саммари PDF-брифа, затем сравнение с указанной вкладкой Google Sheet. Вкладку агент **не меняет**.

### Как запустить

1. Новый чат на каждое мероприятие.
2. Написать, например:

   > Следуй skill Check.
   > Бриф: [прикрепить PDF]
   > Чек-лист: https://docs.google.com/spreadsheets/d/…
   > Вкладка: `название вкладки`

3. Получить в чате (и в `briefs/<slug>-check.md`):
   - саммари **только по брифу**;
   - сверку: совпадения, расхождения, лишнее в ЧЛ, пробелы в ЧЛ, вопросы.

## Skill: Lucy

**Lucy** по PDF-брифу и ссылке на Google Sheet **заполняет** чек-лист и готовит сводный бриф.

### Как запустить

1. Открыть **новый чат** с агентом (на каждое мероприятие — отдельный чат).
2. Написать, например:

   > Следуй skill Lucy.
   > Бриф: [прикрепить PDF]
   > Чек-лист: https://docs.google.com/spreadsheets/d/…
   > Вкладка: `название вкладки`

3. Получить:
   - сводный бриф в чате и в `briefs/<slug>-summary.md`
   - заполненный чек-лист в `checklists/<slug>-checklist.csv`

### Примеры

- Сводный бриф: [briefs/107-vm-25-08-26-summary.md](briefs/107-vm-25-08-26-summary.md)
- Образец в skill: [.cursor/skills/lucy/references/summary-brief-template.md](.cursor/skills/lucy/references/summary-brief-template.md)

### Ограничение

Google Drive MCP читает таблицы, но **не редактирует ячейки** — агент отдаёт CSV для импорта во вкладку Sheet. Подробности в [google-sheets-workflow.md](.cursor/skills/lucy/references/google-sheets-workflow.md).
