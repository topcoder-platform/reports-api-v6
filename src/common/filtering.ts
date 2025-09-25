export type FiltersSplit = {
  include: string[];
  exclude: string[];
};

export function multiValueArrayFilter(filterValue?: string[]) {
  return (filterValue ?? []).reduce<FiltersSplit>(
    (acc, id) => {
      if (id.startsWith("!")) {
        acc.exclude.push(id.slice(1));
      } else {
        acc.include.push(id);
      }
      return acc;
    },
    { include: [], exclude: [] },
  );
}
