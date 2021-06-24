import {
  PaginateOptions,
  SupportThreadInfo,
} from '../models/support-thread-info.model';

export const paginationLimit = 12;

function paginate(
  query,
  options: PaginateOptions,
): Promise<{ all: SupportThreadInfo[]; pagination }> {
  query = query || {};
  options = Object.assign({}, options);

  const sort = options.sort;
  const limit = options.hasOwnProperty('limit') ? options.limit : 10;
  const page = options.page || 1;
  const skip = options.hasOwnProperty('page') ? (page - 1) * limit : 0;
  const all = limit
    ? this.find(query).sort(sort).skip(skip).limit(limit).exec()
    : query.exec();
  const countDocuments = this.countDocuments(query).exec();

  return Promise.all([all, countDocuments]).then(function (values) {
    return Promise.resolve({
      all: values[0],
      pagination: {
        total: values[1],
        limit: limit,
        page: page,
        pages: Math.ceil(values[1] / limit) || 1,
      },
    });
  });
}

export const paginateFn = paginate;

export const pagination = (schema): void => {
  schema.statics.paginate = paginate;
  const self: any = this;
  self.paginate = paginateFn;
};
