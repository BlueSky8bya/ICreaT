abstract class DTO<T, R> {
  R toDomain(T data);
  T fromDomain(R domain);
}

