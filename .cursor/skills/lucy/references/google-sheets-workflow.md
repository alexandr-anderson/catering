# Google Sheets: чтение и запись

## Что работает сейчас

| Действие | Google Drive MCP | Комментарий |
|----------|------------------|-------------|
| Читать файл Sheet | ✅ | `read_file_content`, `download_file_content` |
| Загрузить CSV в Drive | ✅ | `create_file` |
| Редактировать ячейки in-place | ❌ | Нет Sheets API в текущем MCP |

## Рекомендуемый workflow

```
1. Скачать / прочитать шаблон через Drive MCP
2. Заполнить локально (CSV)
3. Сохранить в репозиторий: checklists/<slug>-checklist.csv
4. Загрузить CSV в Google Drive
5. Пользователь импортирует CSV во вкладку Sheet
```

## Импорт CSV пользователем

1. Открыть Google Sheet
2. Выбрать вкладку мероприятия (или создать копию шаблона)
3. **Файл → Импорт → Загрузка** → выбрать CSV
4. Параметры: «Заменить текущий лист» или «Заменить данные в выбранных ячейках» — по ситуации
5. Проверить кодировку UTF-8 (кириллица)

## Извлечение ID таблицы из URL

```
https://docs.google.com/spreadsheets/d/<SPREADSHEET_ID>/edit#gid=<TAB_GID>
```

- `SPREADSHEET_ID` — для Drive MCP
- `TAB_GID` — идентификатор вкладки (для справки; MCP работает с файлом целиком)

## Если MCP недоступен

1. Попросить пользователя экспортировать вкладку: **Файл → Скачать → CSV**
2. Загрузить CSV в чат
3. Заполнить и вернуть обновлённый CSV

## Запись in-place: mcp-google-sheets

Рекомендуемый MCP для прямой записи в ячейки: [diitrashed/mcp-google-sheets](https://github.com/diitrashed/mcp-google-sheets).

### Установка

```bash
bash scripts/install-mcp-google-sheets.sh
```

Или вручную — см. `.cursor/mcp.json.example`.

### Credentials

1. JSON-ключ сервисного аккаунта → `~/mcp-google-sheets/credentials/service-account.json`
2. Расшарить таблицу/папку с шаблонами на `client_email` из JSON с ролью **Editor**
3. Перезапустить MCP в Cursor (Settings → MCP)

### Инструменты для Lucy

| Задача | Tool |
|--------|------|
| Прочитать вкладку | `read_sheet`, `read_range` |
| Записать диапазон | `write_range` |
| Одна ячейка | `update_cell` |
| Список вкладок | `list_sheets` |

Spreadsheet ID из URL: `https://docs.google.com/spreadsheets/d/<ID>/edit`

### Fallback

Если Sheets MCP недоступен или нет credentials — skill **всегда** сохраняет CSV и даёт инструкцию по импорту.
