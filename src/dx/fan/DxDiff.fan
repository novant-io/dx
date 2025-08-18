//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   21 Jul 2024  Andy Frank  Creation
//

*************************************************************************
** DxDiff
*************************************************************************

** DxDiff models a modification to a 'DxRec'.
@Js const class DxDiff
{
  ** Return diff to add a rec to bucket.
  new makeAdd(Str bucket, Str:Obj? map)
  {
    this.bucket = bucket
    this.op  = 0x00
    this.changes = map
  }

  ** Return diff to update an existing rec.
  new makeUpdate(Str bucket, Int id, Str:Obj? changes)
  {
    this.bucket = bucket
    this.op  = 0x01
    this.id  = id
    this.changes = changes
  }

  ** Return diff to delete an existing rec.
  new makeDelete(Str bucket, Int id)
  {
    this.bucket = bucket
    this.op  = 0x02
    this.id  = id
  }

  ** Return diff to add a bucket.
  new makeAddBucket(Str bucket)
  {
    this.bucket = bucket
    this.op  = 0x10
  }

  ** TODO: use Int ref instead of Str [pointer]?
  const Str bucket

  **
  ** Diff op:
  **
  **   0x00 = add
  **   0x01 = update
  **   0x02 = delete
  **   0x10 = add_bucket
  **
  const Int op

  ** The corresponding record id for this diff or 'null' for add.
  const Int? id

  ** Modifications to apply to record.
  const [Str:Obj?]? changes

  ** Iterate id(s) in this diff.
  virtual Void eachId(|Int id| f)
  {
    if (id != null) f(id)
  }

  override Str toStr()
  {
    "{ op:$op bucket:$bucket id:$id mod:$changes }"
  }
}
