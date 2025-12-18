-- RPC-функция для удаления записи из user_storage
CREATE OR REPLACE FUNCTION delete_user_storage_item(p_item_id UUID)
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
  DELETE FROM user_storage 
  WHERE id = p_item_id 
  AND user_id = auth.uid();
END;
$$;