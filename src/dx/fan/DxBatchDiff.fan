//
// Copyright (c) 2025, Novant LLC
// Licensed under the MIT License
//
// History:
//   20 May 2025  Andy Frank  Creation
//

*************************************************************************
** DxBatchDiff
*************************************************************************

** DxBatchDiff models a modification to multiple 'DxRec' instances.
@Js const class DxBatchDiff : DxDiff
{
  ** Return diff to update a list of existing recs.
  new makeUpdate(Str bucket, Int[] ids, Str:Obj? changes) : super(bucket, ids.first, changes)
  {
    this.op  = 0x41
    this.ids = ids
  }

  ** Return diff to delete a list of existing recs.
  new makeDelete(Str bucket, Int[] ids) : super(bucket, ids.first)
  {
    this.op  = 0x42
    this.ids = ids
  }

  ** The corresponding record ids for this diff or 'null' for add.
  const Int[]? ids

  ** Iterate id(s) in this diff.
  override Void eachId(|Int id| f)
  {
    ids.each(f)
  }

  override Str toStr()
  {
    "{ op:$op bucket:$bucket ids:$ids mod:$changes }"
  }
}
