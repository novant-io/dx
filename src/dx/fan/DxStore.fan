//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   21 Jul 2024  Andy Frank  Creation
//

using concurrent

*************************************************************************
** DxStore
*************************************************************************

**
** DxStore manages an immutable set of buckets that each contain
** a list of records.  To modify the contents of Store, create
** a DxWriter to apply a set of changes which produces a new
** Store instance.  No data from previous instances is modified
** so each Store can be used safely between threads.
**
@Js const class DxStore
{
  ** Create a new store and register given buckets.
  new make(Int version, Str:DxRec[] buckets)
  {
    map := Str:ConstMap[:]
    buckets.each |recs, name|
    {
      // TODO: efficient way to pre-seed map?
      c := ConstMap()
      recs.each |r| { c = c.add(r.id, r) }
      map[name] = c
    }
    this.version = version
    this.bmap = map.toImmutable
  }

  ** Create a new modified store instance from a DxWriter commit log.
  new makeWriter(DxWriter writer)
  {
    this.version = writer.nextVer
    this.bmap    = writer.wmap.toImmutable
  }

  ** Version of this store.
  const Int version

  ** Return registered buckets for this store.
  Str[] buckets() { bmap.keys }

  ** Get the number of records in given bucket.
  ** Throws 'ArgErr' if bucket not found.
  Int size(Str bucket)
  {
    b(bucket).size
  }

  ** Get record for given bucket and record id or 'null' if not found.
  DxRec? get(Str bucket, Int id)
  {
    b(bucket).get(id)
  }

  ** Iterate the records in the given bucket.
  Void each(Str bucket, |DxRec rec| f)
  {
    b(bucket).each(f)
  }

  ** Get the first record in given bucket for which callback returns
  ** true, or return 'null' if callback is false for every record.
  DxRec? find(Str bucket, |DxRec->Bool| f)
  {
    // TODO: optimize this!
    DxRec? found
    b(bucket).each |rec|
    {
      if (found != null) return
      if (f(rec) == true) found = rec
    }
    return found
  }

  ** Get bucket or throw 'ArgErr' if not found.
  private ConstMap b(Str name)
  {
    bmap[name] ?: throw ArgErr("Bucket not found '${name}'")
  }

  internal const Str:ConstMap bmap   // map of bucket_name : rec_map
}