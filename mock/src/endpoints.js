const dateFromNow = (days, hours = 0) => {
  const date = new Date();
  date.setDate(date.getDate() + days);
  date.setHours(date.getHours() + hours);
  return date;
};
const subjects = [
  ["S1", "Prg", "Programming"],
  ["S2", "Mat", "Mathematics"],
  ["S3", "Eng", "English"],
  ["S4", "His", "History"],
  ["S5", "Che", "Chemistry"],
  ["S6", "Bio", "Biology"],
  ["S7", "Ger", "German"],
  ["S8", "Phy", "Physics"],
].map(([Id, Abbrev, Name]) => ({ Id, Abbrev, Name }));
const teachers = [
  ["T1", "Tur", "Alan Turing"],
  ["T2", "Tao", "Terence Tao"],
  ["T3", "Aus", "Jane Austen"],
  ["T4", "New", "Isaac Newton"],
  ["T5", "Cur", "Marie Curie"],
  ["T6", "Dar", "Charles Darwin"],
  ["T7", "Goe", "Johann Goethe"],
  ["T8", "Fey", "Richard Feynman"],
].map(([Id, Abbrev, Name]) => ({ Id, Abbrev, Name }));
const rooms = [
  ["R1", "109", "Room 109"],
  ["R2", "203", "Room 203"],
  ["R3", "205", "Room 205"],
  ["R4", "102", "Room 102"],
  ["R5", "Lab1", "Chemistry Lab"],
  ["R6", "Lab2", "Biology Lab"],
  ["R7", "301", "Room 301"],
  ["R8", "311", "Physics Lab"],
].map(([Id, Abbrev, Name]) => ({ Id, Abbrev, Name }));
const toMinutes = (time) => {
  const [hour, minute] = time.split(":").map(Number);
  return hour * 60 + minute;
};
const lessonHours = [
  ["8:00", "8:45"],
  ["8:55", "9:40"],
  ["9:50", "10:35"],
  ["10:45", "11:30"],
  ["11:40", "12:25"],
  ["12:35", "13:20"],
  ["13:30", "14:15"],
  ["14:25", "15:10"],
].map(([begin, end], index) => ({
  Id: index + 1,
  Caption: String(index + 1),
  BeginTime: begin,
  EndTime: end,
  Start: toMinutes(begin),
  Duration: 45,
}));
const weeklyTimetable = [
  [
    [3, "Present perfect"],
    [2, "Quadratic equations"],
    [1, "Algorithms"],
    [1, "Binary search"],
    [8, "Electric current"],
    null,
    [2, "Linear functions"],
    [5, "Chemical reactions"],
  ],
  [
    [2, "Functions and graphs"],
    [1, "Object-oriented programming"],
    [7, "German grammar"],
    [5, "Periodic table"],
    [8, "Magnetic field"],
    [4, "World War II"],
    null,
    [6, "Cell biology"],
  ],
  [
    [3, "Everyday conversations"],
    [2, "Systems of equations"],
    [1, "Sorting algorithms"],
    [1, "Binary search"],
    null,
    [2, "Trigonometry"],
    [4, "The Cold War"],
    [3, "My future plans"],
  ],
  [
    [2, "Functions"],
    [1, "Algorithms"],
    [5, "Acids and bases"],
    [8, "Kinematics"],
    [3, "Present perfect"],
    null,
    [7, "Travel and holidays"],
    [4, "Modern history"],
  ],
  [
    [1, "Data structures"],
    [3, "Grammar"],
    [2, "Linear equations"],
    [5, "Chemical reactions"],
    [4, "World War II"],
    [8, "Optics"],
    [6, "Genetics"],
    [7, "Vocabulary"],
  ],
];
const findById = (items, id) => items.find((item) => item.Id === id);
const makeAtom = (subjectNumber, hourIndex) => ({
  HourId: hourIndex + 1,
  GroupIds: ["G1"],
  SubjectId: `S${subjectNumber}`,
  TeacherId: `T${subjectNumber}`,
  RoomId: `R${subjectNumber}`,
  CycleIds: ["1"],
  Change: null,
  HomeworkIds: [],
  Start: lessonHours[hourIndex].Start,
  Duration: 45,
});
const makeChangeAtom = (hourId, change) => ({
  HourId: hourId,
  GroupIds: [],
  SubjectId: null,
  TeacherId: null,
  RoomId: null,
  CycleIds: [],
  Change: change,
  HomeworkIds: [],
  Theme: null,
  Start: lessonHours[hourId - 1].Start,
  Duration: 45,
});
const eventTypes = {
  school: { Id: "SA", Abbrev: "School", Name: "School event" },
  holiday: { Id: "HD", Abbrev: "Holiday", Name: "Holiday" },
  public: { Id: "PB", Abbrev: "Public", Name: "Public event" },
};
const eventClasses = [{ Id: "C1", Abbrev: "3.A", Name: "3. A" }];
const makeEvent = ({
  id,
  title,
  description,
  days,
  duration,
  wholeDay,
  type,
  teacherIds = [],
  roomIds = [],
  includeClass = true,
}) => ({
  Id: id,
  Title: title,
  Description: description,
  Times: [
    {
      WholeDay: wholeDay,
      StartTime: dateFromNow(days).toISOString(),
      EndTime: dateFromNow(days, duration).toISOString(),
    },
  ],
  EventType: eventTypes[type],
  Classes: includeClass ? eventClasses : [],
  Teachers: teacherIds.map((teacherId) => findById(teachers, teacherId)),
  Rooms: roomIds.map((roomId) => findById(rooms, roomId)),
});
const makeEvents = () => [
  makeEvent({
    id: "DEBUG_EVENT_MY_1",
    title: "School trip to the science museum",
    description: "Whole-day trip. Bring a packed lunch and comfortable shoes.",
    days: 7,
    duration: 0,
    wholeDay: true,
    type: "school",
    teacherIds: ["T8"],
    roomIds: ["R3"],
  }),
  makeEvent({
    id: "DEBUG_EVENT_MY_2",
    title: "Parents' evening",
    description: "Meeting with teachers in the school hall.",
    days: 2,
    duration: 2,
    wholeDay: false,
    type: "school",
    teacherIds: ["T1", "T2", "T3", "T4"],
    roomIds: ["R1"],
  }),
  makeEvent({
    id: "DEBUG_EVENT_MY_3",
    title: "Programming project week",
    description:
      "Work on your programming projects and present the results at the end of the week.",
    days: 20,
    duration: 48,
    wholeDay: false,
    type: "school",
    teacherIds: ["T1", "T3"],
    roomIds: ["R1"],
  }),
  makeEvent({
    id: "DEBUG_EVENT_MY_4",
    title: "Alumni talk",
    description: "Former students talk about their studies and careers.",
    days: -10,
    duration: 2,
    wholeDay: false,
    type: "school",
    teacherIds: ["T2"],
    roomIds: ["R2"],
  }),
  makeEvent({
    id: "DEBUG_EVENT_PUBLIC_1",
    title: "School break",
    description: "School is closed for the whole week.",
    days: 10,
    duration: 96,
    wholeDay: true,
    type: "holiday",
    includeClass: false,
  }),
  makeEvent({
    id: "DEBUG_EVENT_PUBLIC_2",
    title: "Open day",
    description: "Come and see the school. Everyone is welcome.",
    days: 15,
    duration: 7,
    wholeDay: false,
    type: "public",
    teacherIds: ["T1", "T2"],
    roomIds: ["R1", "R2"],
  }),
  makeEvent({
    id: "DEBUG_EVENT_PUBLIC_3",
    title: "Foundation day",
    description: "Anniversary of the school foundation.",
    days: -30,
    duration: 0,
    wholeDay: true,
    type: "public",
    includeClass: false,
  }),
];
const findSubjectTeacher = (subject) =>
  findById(teachers, `T${subject.Id.slice(1)}`);
const makeSubjectRows = () =>
  subjects.map((subject) => {
    const teacher = findSubjectTeacher(subject);
    return {
      SubjectID: subject.Id,
      SubjectName: subject.Name,
      SubjectAbbrev: subject.Abbrev,
      TeacherID: teacher.Id,
      TeacherName: teacher.Name,
      TeacherAbbrev: teacher.Abbrev,
    };
  });
const makeSubjectThemes = (subjectId) => {
  const subject = findById(subjects, subjectId);
  if (!subject) return { Subject: null, Themes: [] };

  const subjectNumber = Number(subject.Id.slice(1));
  const themes = [];
  weeklyTimetable.forEach((lessons, dayIndex) => {
    const date = dateFromNow(dayIndex - 7);
    date.setHours(0, 0, 0, 0);
    lessons.forEach((lesson, hourIndex) => {
      if (!lesson || lesson[0] !== subjectNumber) return;
      themes.push({
        Date: date.toISOString(),
        Theme: lesson[1],
        Note: "",
        HourCaption: `${hourIndex + 1}. hod`,
        LessonLabel: String(themes.length + 1),
      });
    });
  });

  return {
    Subject: { Id: subject.Id, Abbrev: subject.Abbrev, Name: subject.Name },
    Themes: themes,
  };
};

const endpoints = {
  login: () => ({
    access_token: "DEBUG_ACCESS_TOKEN",
  }),
  user: () => ({
    FullName: "Sheldon Cooper",
    UserTypeText: "student",
  }),
  marks: () => ({
    Subjects: [
      {
        Marks: [
          {
            MarkDate: "2026-02-24",
            Caption: "Test 1",
            Theme: "Algorithms",
            MarkText: "1",
            Weight: 5,
          },
          {
            MarkDate: "2026-03-10",
            Caption: "Practical exam",
            Theme: "Sorting algorithms",
            MarkText: "2",
            Weight: 8,
          },
          {
            MarkDate: "2026-03-18",
            Caption: "Homework",
            Theme: "Binary search",
            MarkText: "1",
            Weight: 3,
          },
          {
            MarkDate: "2026-04-02",
            Caption: "Test 2",
            Theme: "Data structures",
            MarkText: "3",
            Weight: 5,
          },
          {
            MarkDate: "2026-04-15",
            Caption: "Project",
            Theme: "Object-oriented programming",
            MarkText: "1",
            Weight: 10,
          },
        ],
        Subject: { Name: "Programming" },
        SubjectNote: "Finds bugs in my programs",
      },
      {
        Marks: [
          {
            MarkDate: "2026-02-25",
            Caption: "Test 1",
            Theme: "Linear equations",
            MarkText: "2",
            Weight: 5,
          },
          {
            MarkDate: "2026-03-12",
            Caption: "Quiz",
            Theme: "Quadratic equations",
            MarkText: "1",
            Weight: 3,
          },
          {
            MarkDate: "2026-03-26",
            Caption: "Test 2",
            Theme: "Functions",
            MarkText: "3",
            Weight: 7,
          },
          {
            MarkDate: "2026-04-09",
            Caption: "Homework",
            Theme: "Trigonometry",
            MarkText: "1",
            Weight: 2,
          },
        ],
        Subject: { Name: "Mathematics" },
        SubjectNote: "",
      },
      {
        Marks: [
          {
            MarkDate: "2026-02-26",
            Caption: "Vocabulary test",
            Theme: "Unit 5",
            MarkText: "1",
            Weight: 4,
          },
          {
            MarkDate: "2026-03-11",
            Caption: "Grammar test",
            Theme: "Present perfect",
            MarkText: "2",
            Weight: 5,
          },
          {
            MarkDate: "2026-03-30",
            Caption: "Essay",
            Theme: "My future plans",
            MarkText: "1",
            Weight: 8,
          },
        ],
        Subject: { Name: "English" },
        SubjectNote: "",
      },
      {
        Marks: [
          {
            MarkDate: "2026-02-27",
            Caption: "Test 1",
            Theme: "World War II",
            MarkText: "2",
            Weight: 5,
          },
          {
            MarkDate: "2026-03-17",
            Caption: "Oral exam",
            Theme: "The Cold War",
            MarkText: "1",
            Weight: 6,
          },
          {
            MarkDate: "2026-04-01",
            Caption: "Test 2",
            Theme: "Modern history",
            MarkText: "3",
            Weight: 5,
          },
        ],
        Subject: { Name: "History" },
        SubjectNote: "",
      },
      {
        Marks: [
          {
            MarkDate: "2026-03-03",
            Caption: "Lab report",
            Theme: "Chemical reactions",
            MarkText: "1",
            Weight: 7,
          },
          {
            MarkDate: "2026-03-20",
            Caption: "Test 1",
            Theme: "Periodic table",
            MarkText: "2",
            Weight: 5,
          },
          {
            MarkDate: "2026-04-07",
            Caption: "Quiz",
            Theme: "Acids and bases",
            MarkText: "1",
            Weight: 3,
          },
        ],
        Subject: { Name: "Chemistry" },
        SubjectNote: "",
      },
      {
        Marks: [
          {
            MarkDate: "2026-03-05",
            Caption: "Test 1",
            Theme: "Cell biology",
            MarkText: "2",
            Weight: 5,
          },
          {
            MarkDate: "2026-03-24",
            Caption: "Project",
            Theme: "Human body",
            MarkText: "1",
            Weight: 8,
          },
          {
            MarkDate: "2026-04-10",
            Caption: "Test 2",
            Theme: "Genetics",
            MarkText: "3",
            Weight: 5,
          },
        ],
        Subject: { Name: "Biology" },
        SubjectNote: "",
      },
      {
        Marks: [
          {
            MarkDate: "2026-03-02",
            Caption: "Listening",
            Theme: "Everyday conversations",
            MarkText: "1",
            Weight: 3,
          },
          {
            MarkDate: "2026-03-19",
            Caption: "Test 1",
            Theme: "German grammar",
            MarkText: "2",
            Weight: 5,
          },
          {
            MarkDate: "2026-04-06",
            Caption: "Vocabulary",
            Theme: "Travel and holidays",
            MarkText: "1",
            Weight: 4,
          },
        ],
        Subject: { Name: "German" },
        SubjectNote: "",
      },
      {
        Marks: [
          {
            MarkDate: "2026-03-06",
            Caption: "Test 1",
            Theme: "Kinematics",
            MarkText: "2",
            Weight: 5,
          },
          {
            MarkDate: "2026-03-25",
            Caption: "Lab work",
            Theme: "Electric circuits",
            MarkText: "1",
            Weight: 7,
          },
          {
            MarkDate: "2026-04-13",
            Caption: "Test 2",
            Theme: "Optics",
            MarkText: "3",
            Weight: 5,
          },
        ],
        Subject: { Name: "Physics" },
        SubjectNote: "",
      },
    ],
  }),
  homeworks: () => ({
    Homeworks: [
      {
        ID: "DEBUG_HW_ID_1",
        DateStart: dateFromNow(-8),
        DateEnd: dateFromNow(7),
        Content: "Finish BakaLite app.",
        Done: false,
        Closed: false,
        Subject: { Name: "Programming" },
        Attachments: [],
        Finished: false,
      },
      {
        ID: "DEBUG_HW_ID_2",
        DateStart: dateFromNow(-5),
        DateEnd: dateFromNow(1),
        Content: "Complete exercises on quadratic equations.",
        Done: false,
        Closed: false,
        Subject: { Name: "Mathematics" },
        Attachments: [],
        Finished: true,
      },
      {
        ID: "DEBUG_HW_ID_3",
        DateStart: dateFromNow(-3),
        DateEnd: dateFromNow(3),
        Content: "Write an essay about climate change.",
        Done: false,
        Closed: false,
        Subject: { Name: "English" },
        Attachments: [],
        Finished: false,
      },
      {
        ID: "DEBUG_HW_ID_4",
        DateStart: dateFromNow(-10),
        DateEnd: dateFromNow(-2),
        Content: "Prepare a presentation about World War II.",
        Done: false,
        Closed: false,
        Subject: { Name: "History" },
        Attachments: [],
        Finished: true,
      },
      {
        ID: "DEBUG_HW_ID_5",
        DateStart: dateFromNow(-10),
        DateEnd: dateFromNow(-5),
        Content: "Calculate the molar mass of the assigned compounds.",
        Done: false,
        Closed: false,
        Subject: { Name: "Chemistry" },
        Attachments: [],
        Finished: false,
      },
      {
        ID: "DEBUG_HW_ID_6",
        DateStart: dateFromNow(-8),
        DateEnd: dateFromNow(-5),
        Content: "Label the parts of a human cell.",
        Done: true,
        Closed: true,
        Subject: { Name: "Biology" },
        Attachments: [],
        Finished: true,
      },
      {
        ID: "DEBUG_HW_ID_7",
        DateStart: dateFromNow(-3),
        DateEnd: dateFromNow(-1),
        Content: "Complete the exercises about functions and graphs.",
        Done: true,
        Closed: true,
        Subject: { Name: "Mathematics" },
        Attachments: [],
        Finished: true,
      },
    ],
  }),
  "timetable/permanent": () => ({
    Hours: lessonHours,
    Days: weeklyTimetable.map((lessons, dayIndex) => ({
      Atoms: lessons
        .map((lesson, hourIndex) => lesson && makeAtom(lesson[0], hourIndex))
        .filter(Boolean),
      DayOfWeek: dayIndex + 1,
      DayDescription: "",
      DayType: "WorkDay",
    })),
    Classes: eventClasses,
    Groups: [{ ClassId: "C1", Id: "G1", Abbrev: "3.A", Name: "3. A" }],
    Subjects: subjects,
    Teachers: teachers,
    Rooms: rooms,
    Cycles: [{ Id: "1", Abbrev: "A", Name: "Cycle A" }],
  }),
  "timetable/actual": () => {
    const timetableData = endpoints["timetable/permanent"]();

    timetableData.Days.forEach((day, dayIndex) => {
      day.Date = dateFromNow(dayIndex + 1);
      day.Atoms.forEach((atom) => {
        atom.Theme = weeklyTimetable[dayIndex][atom.HourId - 1][1];
      });
    });

    timetableData.Days[0].DayDescription = "Public holiday";
    timetableData.Days[0].DayType = "Holiday";
    timetableData.Days[0].Atoms = [];

    const tuesday = timetableData.Days[1];
    tuesday.Atoms = [
      ...tuesday.Atoms.filter((atom) => atom.HourId !== 6),
      makeChangeAtom(6, {
        ChangeSubject: null,
        Day: `${dateFromNow(2).toISOString().slice(0, 10)}T00:00:00+01:00`,
        Hours: "6th lesson",
        ChangeType: "Canceled",
        Description: "Class absence",
        Time: "12:35 - 13:20",
        TypeAbbrev: "Absc",
        TypeName: "Class absence",
        Start: 755,
        Duration: 45,
      }),
    ];

    const friday = timetableData.Days[4];
    friday.Atoms = [
      ...friday.Atoms.filter((atom) => atom.HourId !== 5 && atom.HourId !== 6),
      ...[5, 6].map((hourId) =>
        makeChangeAtom(hourId, {
          ChangeSubject: null,
          Day: `${dateFromNow(5).toISOString().slice(0, 10)}T00:00:00+01:00`,
          Hours: "5th - 6th lesson",
          ChangeType: "Added",
          Description: "Alumni talk",
          Time: "11:40 - 13:20",
          TypeAbbrev: "Act",
          TypeName: "Action",
          Start: 700,
          Duration: 100,
        }),
      ),
    ];

    timetableData.Days.forEach((day) => {
      day.Atoms.sort((a, b) => a.HourId - b.HourId);
    });

    return timetableData;
  },
  "komens/message-types": () => ({
    MessageTypes: [
      { Abbreviation: "GENERAL", Name: "General message" },
      { Abbreviation: "ANNOUNCEMENT", Name: "Announcement" },
    ],
    Recipients: [
      { Code: "T1", Name: "Alan Turing" },
      { Code: "T2", Name: "Jane Austen" },
      { Code: "T3", Name: "Terence Tao" },
      { Code: "T4", Name: "Isaac Newton" },
      { Code: "T5", Name: "Marie Curie" },
      { Code: "T8", Name: "Richard Feynman" },
    ],
  }),
  "komens/messages/received": () => ({
    Messages: [
      {
        Id: "MSG_R1",
        Title: "Welcome to the new school year",
        Type: "GENERAL",
        SentDate: "2026-11-08T09:15:00+01:00",
        RelevantName: "Alan Turing",
        Read: true,
        Text: "<p>Welcome to the new school year!</p><p>I hope you had a great summer break. We will be using this platform for sharing assignments, important information and class materials.</p><p>Best regards,<br>Alan Turing</p>",
        Attachments: [],
      },
      {
        Id: "MSG_R2",
        Title: "Physics test – preparation",
        Type: "GENERAL",
        SentDate: "2026-11-20T14:30:00+01:00",
        RelevantName: "Richard Feynman",
        Read: false,
        Confirmed: false,
        CanConfirm: true,
        Text: "<p>Our physics test will take place next week.</p><p>It will cover electric circuits, Ohm's law and series and parallel connections. Please review your notes and the exercises from the last two lessons.</p>",
        Attachments: [],
      },
      {
        Id: "MSG_R3",
        Title: "Change of classroom",
        Type: "GENERAL",
        SentDate: "2026-11-25T07:25:00+01:00",
        RelevantName: "Jane Austen",
        Read: false,
        Text: "<p>Today's English lesson will take place in <b>Room 205</b> instead of our usual classroom.</p><p>The lesson will start at the regular time. Please let your classmates know.</p>",
        Attachments: [],
      },
    ],
  }),
  "komens/messages/sent": () => ({
    Messages: [
      {
        Id: "MSG_S1",
        Title: "Question about homework",
        Type: "GENERAL",
        SentDate: "2026-11-12T16:45:00+01:00",
        RelevantName: "Terence Tao",
        Read: true,
        Text: "<p>Could you please explain exercise 7 from the latest assignment? I am not sure how to approach the second part.</p>",
        Attachments: [],
      },
      {
        Id: "MSG_S2",
        Title: "Re: Programming project",
        Type: "GENERAL",
        SentDate: "2026-11-21T19:10:00+01:00",
        RelevantName: "Alan Turing",
        Read: true,
        Text: "<p>Would it be possible to use Python for the project?</p><p>I would also like to know whether using external libraries is allowed.</p>",
        Attachments: [],
      },
    ],
  }),
  "komens/messages/noticeboard": () => ({
    Messages: [
      {
        Id: "MSG_N1",
        Title: "Parents' evening",
        Type: "ANNOUNCEMENT",
        SentDate: "2026-10-15T12:00:00+02:00",
        RelevantName: "School office",
        Read: true,
        Text: "<p>Parents' evening takes place on 15 October at 17:00.</p><p>Parents can meet teachers in their respective classrooms.</p>",
        Attachments: [],
      },
      {
        Id: "MSG_N2",
        Title: "Student programming competition",
        Type: "ANNOUNCEMENT",
        SentDate: "2026-11-12T10:00:00+01:00",
        RelevantName: "School office",
        Read: false,
        Text: "<p>Students interested in programming are invited to participate in the annual school programming competition.</p><p>Registration is open until 27 November. No previous competition experience is required.</p>",
        Attachments: [],
      },
      {
        Id: "MSG_N3",
        Title: "Winter break",
        Type: "ANNOUNCEMENT",
        SentDate: "2026-11-26T12:00:00+01:00",
        RelevantName: "School office",
        Read: false,
        Text: "<p>The winter break schedule has been published.</p><p>More information about the last school day before the holidays will be provided by your class teachers.</p>",
        Attachments: [],
      },
    ],
  }),
  subjects: () => ({
    Subjects: makeSubjectRows(),
  }),
  "subjects/themes": (subjectId) => makeSubjectThemes(subjectId),
  events: () => ({
    Events: makeEvents(),
  }),
  "events/my": () => ({
    Events: makeEvents().filter((event) => event.EventType.Id === "SA"),
  }),
  "events/public": () => ({
    Events: makeEvents().filter((event) => event.EventType.Id !== "SA"),
  }),
};

export default endpoints;
