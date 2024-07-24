//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   21 Jul 2024  Andy Frank  Creation
//

using concurrent

*************************************************************************
** DxRec
*************************************************************************

** DxRec models a record of name-value fields.
@Js const class DxRec
{
  ** Construct a new DxRec instance.
  new make(Str:Obj? map := [:])
  {
    this.map = map
    this.id  = map["id"] ?: throw ArgErr("Missing 'id' key")

    // record ids must be within 1..4294967295
    if (id  < 1 || id  > 0xffff_ffff) throw ArgErr("Record id out of bounds: $id")
  }

  ** Convenience for 'rec->id' to get the unique ID
  ** for this record within the dataset.
  const Int id

  ** Get the value for the given `key` or 'null' if not found.
  @Operator
  Obj? get(Str key)
  {
    map[key]
  }

  ** Iterate the values and keys in this record.
  Void each(|Obj? val, Str key| f)
  {
    map.each |v,k| { f(v,k) }
  }

  ** Merge the given changes with the current record and
  ** return a new instance.
  DxRec merge(Str:Obj? changes)
  {
    temp := map.dup
    changes.each |v,k|
    {
      // can never modify id
      if (k == "id") return
      if (v == null) temp.remove(k)
      else temp[k] = v
    }
    return DxRec(temp)
  }

  **
  ** Convenience for `get`:
  **
  **   foo := rec.get("foo")
  **   foo := rec->foo
  **
  override Obj? trap(Str name, Obj?[]? val := null)
  {
    if (val == null || val.size == 0) return get(name)
    return null
  }

  private const Str:Obj? map
}
