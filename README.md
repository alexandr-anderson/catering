# catering

Проект кейтеринга: автоматизация подготовки чек-листов мероприятий по клиентским брифам.

## Skill: Lucy

В репозитории есть skill для агента Cursor — `.cursor/skills/lucy/SKILL.md`.

**Lucy** по PDF-брифу и ссылке на Google Sheet заполняет чек-лист и готовит **сводный бриф** (краткая выжимка для менеджера).

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
