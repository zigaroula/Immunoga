package {
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.resource.component.EntityBundle;
	import com.ktm.genome.core.entity.IEntityManager;
	
	public class EntityFactory {
		static public function createResourcedEntity(em:IEntityManager, _source:String, _id:String):void {
			// Creation d'une entité vide
			var e:IEntity = em.create();
			// Ajout du composant EntityBundle à cette entité et initialisation de ces trois propriétés : source, id et toBuild
			em.addComponent(e, EntityBundle, { source: _source, id: _id, toBuild: true } );
		}
	}
}