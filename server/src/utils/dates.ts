export function getNextDay(date: Date): Date {
  return new Date(date.setDate(date.getDate() + 1));
}

export function getArrayOfDatesFrom(from: Date, to: Date = new Date()): Date[] {
  for (var arr = [], dt = new Date(from); dt <= new Date(to); getNextDay(dt)) {
    arr.push(new Date(dt));
  }
  return arr;
}
