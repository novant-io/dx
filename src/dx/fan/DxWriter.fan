//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   21 Jul 2024  Andy Frank  Creation
//

*************************************************************************
** DxWriter
*************************************************************************

** DxWriter manages mutations to a DxStore.
@Js class DxWriter
{
  ** Constructor.
  new make(DxStore store)
  {
    // create working copy of buckets
    store.bmap.each |v,k| { wmap[k] = v }
    this.nextVer = store.version + 1
  }

  ** Convenience for 'apply(DxDiff.makeAdd)'.
  virtual This add(Str bucket, Str:Obj? map)
  {
    apply(DxDiff.makeAdd(bucket, map))
  }

  ** Convenience for 'apply(DxDiff.makeUpdate)'.
  virtual This update(Str bucket, Int id, Str:Obj? changes)
  {
    apply(DxDiff.makeUpdate(bucket, id, changes))
  }

  ** Convenience for 'apply(DxDiff.makeDelete)'.
  virtual This delete(Str bucket, Int id)
  {
    apply(DxDiff.makeDelete(bucket, id))
  }

  ** Convenience for 'apply(DxDiff.makeAddBucket)'.
  virtual This addBucket(Str bucket)
  {
    apply(DxDiff.makeAddBucket(bucket))
  }

  ** Apply a list of diffs and update current store instance state.
  virtual This apply(DxDiff diff)
  {
    switch (diff.op)
    {
      // add
      case 0x00:
        b := diff.bucket
        r := newRec(diff)
        wmap[b] = wmap[b].add(r.id, r)

      // update
      case 0x01:
        b := diff.bucket
        r := (DxRec?)wmap[b].get(diff.id)
        if (r == null) throw ArgErr("Record not found '${diff.id}'")
        u := mergeRec(r, diff)
        wmap[b] = wmap[b].set(diff.id, u)

      // delete
      case 0x02:
        b := diff.bucket
        deleteRec(diff)
        wmap[b] = wmap[b].remove(diff.id)

      // add_bucket
      case 0x10:
        b := diff.bucket
        wmap[b] = ConstMap()
    }

    return this
  }

  ** Subclass hook to override 'add' rec behavior.
  protected virtual DxRec newRec(DxDiff diff)
  {
    makeRec(diff.changes)
  }

  ** Subclass hook to override 'update' rec behavior.
  protected virtual DxRec mergeRec(DxRec rec, DxDiff diff)
  {
    temp := rec.map.dup
    diff.changes.each |v,k|
    {
      // can never modify id
      if (k == "id") return
      if (v == null) temp.remove(k)
      else temp[k] = v
    }
    return makeRec(temp)
  }

  ** Subclass hook to create 'DxRec' instance from given field map.
  protected virtual DxRec makeRec(Str:Obj? map)
  {
    DxRec(map)
  }

  ** Subclass hook to override 'delete' rec behavior.
  protected virtual Void deleteRec(DxDiff diff)
  {
  }

  ** Commit the current changes and return a new DxStore.
  virtual DxStore commit()
  {
    // TODO: we mark this writer as commited an no longer usable?
    return DxStore.makeWriter(this)
  }

  internal const Int nextVer         // version to apply on commit
  internal Str:ConstMap wmap := [:]  // map of bucket_name : working rec_map
}
